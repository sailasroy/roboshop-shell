DATE=$(date +%F)
    SCRIPT_NAME=$0
    LOGFILE=/tmp/$SCRIPT_NAME-$DATE.log
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

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
    VALIDATE $? "Downloading the catalogue artifact"

cd /app 
    VALIDATE $? "Opening app directory"

unzip /tmp/catalogue.zip
    VALIDATE $? "Unzipping catalogue artifact"

cd /app
    VALIDATE $? "Opening app directory"

npm install 
    VALIDATE $? "Installing nodejs dependencies"

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service
    VALIDATE "Copying catalogue.service"

systemctl daemon-reload
    VALIDATE $? "Reloading catalogue.service"

systemctl enable catalogue
    VALIDATE $? "Enabling catalogue.service"

systemctl start catalogue
    VALIDATE $? "Starting catalogue.service"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE
    VALIDATE $? "Copying mongo.repo"

yum install mongodb-org-shell -y
    VALIDATE $? "Installing mongodb client"

mongo --host mongodb.sailasdevops.online </app/schema/catalogue.js
    VALIDATE $? "Uploading catalogue products through mongodb"
