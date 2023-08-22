#!/bin/bash

DATE=$(date +%F)
    SCRIPT_NAME=$0
    LOGFILE=/tmp/$SCRIPT_NAME-$DATE.log
    R="\e[31m"
    G="\e[32m"
    N="\e[0m"

USERID=$(id -u)
if [ $? -ne 0 ]
then
echo "ERROR:: Please sign in with root access"
exit 1
fi

VALIDATE(){
if ($1 -ne 0)
then
echo -e "$2 ........$R FAILURE $N"
exit 1
else 
echo -e "$2............$G SUCCESS $N"
fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &<<$LOGFILE
VALIDATE $? "mongo.repo copied to yum.repos.d"
yum install mongodb-org -y &<<$LOGFILE
VALIDATE $? "mongodb installation"
systemctl enable mongod &<<$LOGFILE
VALIDATE $? "enabling mongod"
systemctl start mongod &<<$LOGFILE
VALIDATE $? "mongodb starting"
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &<<$LOGFILE
VALIDATE $? "changing mongod.conf address"
systemctl restart mongod &<<$LOGFILE
VALIDATE $? "restarting mongodb"








