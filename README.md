# cnic-punch
cnic单位 打卡工具app（“我来我往”）自动定时打卡shell脚本


## 使用步骤方法
### 1.在userNamePassword中添加需要打卡的用户和密码
```
#例如 添加邮箱用户 Tom@email.cn 密码：xxxxx
echo "userName=Tom@email.cn2&password=xxxxx" > 
```
### 2.设置定时任务 crontab -e
```
#例如：每天早上 8点整 执行上班打卡任务（随机在之后的0-12分钟内打卡），每天19点16分执行打卡下班任务（随机在之后的0-12分钟内打卡）
#参数 1 或 2 分别表示  上 、下 班  
  
crontab -e

0 8 * * 1-5 . /home/Ove/workspace/punch/punch-all.sh  1 &
16 19 * * 1-5 . /home/Ove/workspace/punch/punch-all.sh 2  &
```
