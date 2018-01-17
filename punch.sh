##/bin/sh
#
#author：
#       Ove
#date：
#       2018-1-17
#
#模拟会话定时自动打卡（上班、下班）
#
#接收参数格式如下：
#	参数1：账号密码，格式如下
# 		userName=xxxx&password=xxxxx
#	参数2：上班=1、下班=2，格式如下
#			1
#			2
#	参数3：每一个用户对应的用户id 

#cookie、token文件存放的路径
intermediate_dir=/home/Ove/workspace/punch/intermediate_dir
user_id=$3

if [ $# -lt 1 ]; then
	echo "账号密码参数不能为空"
	exit 1
fi

if [ $# -lt 2 ]; then
	echo "上下班参数不能为空"
	exit 2
fi

if [ $2 -lt 1 ]; then
	echo "上下班参数错误，上班=1、下班=2"
	exit 2
fi

if [ $2 -gt 2 ]; then
        echo "上下班参数错误，上班=1、下班=2"
        exit 2
fi

#随机等待 0-12分钟内打卡
time=$(date +%s)
waittime=$(($time % 13))
sleep "$waittime"s

#获取通行证cookie
curl -c $intermediate_dir/$user_id-cookies.txt -H 'Content-Type=application/x-www-form-urlencoded' -d $1"&response_type=code&redirect_uri=http://159.226.29.10/CnicCheck/testtoken&client_id=58861&theme=simple&pageinfo=userinfo&tm=123" https://passport.escience.cn/oauth2/authorize > /dev/null
#检查是否成功获取session中passport.escience.cn字段,没有表示登录失败
head  $intermediate_dir/$user_id-cookies.txt |grep "passport.escience.cn" > /dev/null
if [ $? -ne 0 ]; then
	echo $1",验证失败，请检查账号密码是否正确"
	exit 3
fi
#利用上一个cookies验证，获取带token的结果
curl -L -b $intermediate_dir/$user_id-cookies.txt -c $intermediate_dir/$user_id-cookies2.txt  -G http://159.226.29.10/CnicCheck/authorization > $intermediate_dir/$user_id-authorization.result

#检查authorization结果中是否含有token，有表示验证成功
head -1 $intermediate_dir/$user_id-authorization.result |grep "token" > /dev/null
if [ $? -ne 0 ]; then
	echo $1",根据cookies获取token失败"
	exit 4
fi

#获取token字段
token=$(head -1 $intermediate_dir/$user_id-authorization.result)
token=${token:10:32}
if [ $2 -eq 1 ]; then
	# 上班打卡
	date >> $intermediate_dir/$user_id.result
	curl -L -b $intermediate_dir/$user_id-cookies2.txt  -G -d "weidu=39.97943495591847&jingdu=116.32850166009715&type=checkin&token="$token http://159.226.29.10/CnicCheck/CheckServlet >> $intermediate_dir/$user_id.result
else
	# 下班打卡
	date >> $intermediate_dir/$user_id.result
	curl -L -b $intermediate_dir/$user_id-cookies2.txt  -G -d "weidu=39.97943495591847&jingdu=116.32850166009715&type=checkout&token="$token http://159.226.29.10/CnicCheck/CheckServlet >> $intermediate_dir/$user_id.result
fi


#检查authorization结果中是否含有{"errorMessage":"","success":"true"}，有表示验证成功
tail -1 $intermediate_dir/$user_id.result |grep '{"errorMessage":"","success":"true"}' > /dev/null
#记录执行的情况
if [ $? -ne 0 ]; then
	echo $username_passwd-打卡失败 >> $intermediate_dir/$user_id.result
else
	echo $username_passwd-打卡成功 >> $intermediate_dir/$user_id.result
fi

