#!/bin/bash
DATE=$(date +%F)
    SCRIPT_NAME=$0
    LOGFILE=/tmp/$SCRIPT_NAME-$DATE.log
   # https://github.com/sailasroy/roboshop-shell.git=/tmp/$SCRIPT_NAME-$DATE.log
    R="\e[31m"
    G="\e[32m"
    N="\e[0m"

USERID=$(id -u)
if [ $USERID -ne 0 ]
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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash 
    VALIDATE $? "Dowloading nodejs source file"
yum install nodejs -y 
    VALIDATE $? "Installing nodejs"  
useradd roboshop

mkdir /app

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip 
    VALIDATE $? "Downloading the cart artifact"

cd /app 
    VALIDATE $? "Opening app directory"

unzip /tmp/cart.zip 
    VALIDATE $? "Unzipping cart artifact"

cd /app 
    VALIDATE $? "Opening app directory"

npm install 
    VALIDATE $? "Installing nodejs dependencies"

cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service
    VALIDATE $? "Copying cart.service"

systemctl daemon-reload 
    VALIDATE $? "Reloading cart.service"

systemctl enable cart 
    VALIDATE $? "Enabling cart.service"

systemctl start cart 
    VALIDATE $? "Starting cart.service"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo 
    VALIDATE $? "Copying mongo.repo"

yum install mongodb-org-shell -y 
    VALIDATE $? "Installing mongodb client"

# mongo --host mongodb.sailasdevops.online </app/schema/cart.js &>>$LOGFILE
#     VALIDATE $? "Uploading cart products through mongodb"