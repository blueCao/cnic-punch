curl -c cookies.txt -H 'Content-Type=application/x-www-form-urlencoded' -d 'userName=caojunhui@cnic.cn&password=13435011052cnic&response_type=code&redirect_uri=http://159.226.29.10/CnicCheck/testtoken&client_id=58861&theme=simple&pageinfo=userinfo&tm=123' https://passport.escience.cn/oauth2/authorize
curl -L -b cookies.txt -c cookies2.txt  -G http://159.226.29.10/CnicCheck/authorization


intermediate_dir=/home/Ove/workspace/punch/intermediate_dir
#获取通行证cookie
curl -c $intermediate_dir/$1-cookies.txt -H 'Content-Type=application/x-www-form-urlencoded' -d $1"&response_type=code&redirect_uri=http://159.226.29.10/CnicCheck/testtoken&client_id=58861&theme=simple&pageinfo=userinfo&tm=123" https://passport.escience.cn/oauth2/authorize
#检查是否成功获取session中passport.escience.cn字段,没有表示登录失败
head  $intermediate_dir/$1-cookies.txt |grep "passport.escience.cn" > /dev/null
if [ $? -ne 0 ]; then
        echo $1",验证失败，请检查账号密码是否正确"
        exit 3
fi
#利用上一个cookies验证，获取带token的结果
curl -L -b $intermediate_dir/$1-cookies.txt -c $intermediate_dir/$1-cookies2.txt  -G http://159.226.29.10/CnicCheck/authorization > $intermediate_dir/$1-authorization.result

