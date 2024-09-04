#!/bin/bash

# Constants for colored output
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

# Log file with timestamp
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

# Started the script
echo "script stareted executing at $TIMESTAMP" &>> $LOGFILE

# Validation function to check the success or failure of a command
VALIDATE(){
    if [ $(id -u) -ne 0 ]; then
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

# Ensure the script is run as root
if [ $(id -u) -ne 0 ]; then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
else
    echo "Running as root user" &>> $LOGFILE
fi

# Copy MongoDB repo
cp mongo.repo /etc/yum.repos.d/ &>> $LOGFILE
VALIDATE $? "Copied MongoDB Repo"

# Install MongoDB
dnf install mongodb-org -y &>> $LOGFILE
VALIDATE $? "Installed MongoDB"

# Enable and start MongoDB service
systemctl enable mongod &>> $LOGFILE
VALIDATE $? "Enabled mongod service"

systemctl start mongod &>> $LOGFILE
VALIDATE $? "Started mongod service"

# Allow remote access by modifying the MongoDB config
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE
VALIDATE $? "Enabled remote access to MongoDB"

# Restart MongoDB service to apply the configuration change
systemctl restart mongod &>> $LOGFILE
VALIDATE $? "Restarted mongod service"