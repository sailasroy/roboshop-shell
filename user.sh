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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE
    VALIDATE $? "Dowloading nodejs source file"
yum install nodejs -y &>>$LOGFILE
    VALIDATE $? "Installing nodejs"  
useradd roboshop

mkdir /app

curl -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>$LOGFILE
    VALIDATE $? "Downloading the user artifact"

cd /app &>>$LOGFILE
    VALIDATE $? "Opening app directory"

unzip /tmp/user.zip &>>$LOGFILE
    VALIDATE $? "Unzipping user artifact"

cd /app &>>$LOGFILE
    VALIDATE $? "Opening app directory"

npm install &>>$LOGFILE
    VALIDATE $? "Installing nodejs dependencies"

cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service &>>$LOGFILE
    VALIDATE $? "Copying user.service"

systemctl daemon-reload &>>$LOGFILE
    VALIDATE $? "Reloading user.service"

systemctl enable user &>>$LOGFILE
    VALIDATE $? "Enabling user.service"

systemctl start user &>>$LOGFILE
    VALIDATE $? "Starting user.service"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE
    VALIDATE $? "Copying mongo.repo"

yum install mongodb-org-shell -y &>>$LOGFILE
    VALIDATE $? "Installing mongodb client"

mongo --host mongodb.sailasdevops.online </app/schema/user.js &>>$LOGFILE
    VALIDATE $? "Uploading user products through mongodb"