#!/bin/bash

DATE=$(date +%F)
    SCRIPT_NAME=$0
    LOGFILE=/tmp/$SCRIPT_NAME-$DATE.log
    R="\e[31m"
    G="\e[32m"
    N="\e[0m"

cartID=$(id -u)
if [ $cartID -ne 0 ]
then
echo -e "$R ERROR:: Please sign in with root access $N"
exit 1
fi

VALIDATE(){
if [ $1 -ne 0 ]
then
echo -e "$2 ........$R FAILURE $N"
exit 1
else 
echo -e "$2............$G SUCCESS $N"
fi
}


yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGFILE
VALIDATE $? "installing redis"


yum module enable redis:remi-6.2 -y &>>$LOGFILE
VALIDATE $? "Enabling Redis 6.2"

yum install redis -y  &>>$LOGFILE
VALIDATE $? "Installing Redis"

systemctl enable redis &>>$LOGFILE
VALIDATE $? "Enabling Redis"

systemctl start redis &>>$LOGFILE
VALIDATE $? "Start Redis"


#sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf &>>$LOGFILE
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf &>>$LOGFILE
VALIDATE $? "Changing the address in redis.conf"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf /etc/redis.conf /etc/redis/redis.conf &>>$LOGFILE


VALIDATE $? "Changing the address in redis.conf"

systemctl restart redis &>>$LOGFILE
VALIDATE $? "REStart Redis"


