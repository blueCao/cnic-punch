#/bin/sh
#
#author：
#       Ove
#date：
#       2018-1-17
#
#	触发所有人的打卡
#
#输入参数：上班打开=1、下班打卡=2
#		1
#		2


#检查 输入参数
if [ $# -lt 1 ]; then
	echo "上下班参数不能为空"
	exit 1
fi

if [ $1 -lt 1 ]; then
        echo "上下班参数错误，上班=1、下班=2"
        exit 2
fi

if [ $1 -gt 2 ]; then
        echo "上下班参数错误，上班=1、下班=2"
        exit 2
fi


#账号密码存文件路径
userNamePasswordFile=/home/Ove/workspace/punch/userNamePassword.txt
#打卡脚本所在路径
checkin_shell=/home/Ove/workspace/punch/punch.sh

#读取账号密码文件（账号密码各为一行)分别执行i
#以行号作为用户id
user_id=1
while read username_passwd
do
	#依次触发打卡
	. $checkin_shell $username_passwd $1 $user_id &
	#用户id自增
	user_id=$(($user_id+1))
done < "$userNamePasswordFile"
