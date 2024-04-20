#!/bin/bash

#variables
DATE=$(date +%F)
LOGSDIR=/tmp
# /home/centos/shellscript-logs/script-name-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];
then 
    echo -e "$R ERROR:: polease run this script with root access $N"
    exit 1
fi

#funtion to use the required places
VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "copied the Mongo DB into mongo.repo.d ..."

yum install mongodb-org -y &>> $LOGFILE
VALIDATE $? "installation of mango DB"

systemctl enable mongod &>> $LOGFILE
VALIDATE $? "enabled the mangod service"

systemctl start mongod &>> $LOGFILE
VALIDATE $? "Started the mangod service"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE
VALIDATE $? "Edited MongoDB conf"

systemctl restart mongod &>> $LOGFILE
VALIDATE $? "Restarting MonogoDB"