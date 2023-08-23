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

yum install nginx -y &>>$LOGFILE
    VALIDATE $? "Installing Nginx"

systemctl enable nginx &>>$LOGFILE
    VALIDATE $? "Enabling Nginx"

systemctl start nginx &>>$LOGFILE
    VALIDATE $? "Starting Nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
    VALIDATE $? "Deleting old html files"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$LOGFILE
    VALIDATE $? "Copying the html files"

cd /usr/share/nginx/html &>>$LOGFILE

    VALIDATE $? "moving to the html directory"

unzip /tmp/web.zip &>>$LOGFILE
    VALIDATE $? "Unzipping the html file"

cp /home/centos/robosho-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$LOGFILE
    VALIDATE $? "Copying roboshop.conf"

systemctl restart nginx &>>$LOGFILE
    VALIDATE $? "Restarting Nginx"
