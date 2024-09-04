#!/bin/bash

# Constants for colored output
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

MONGDB_HOST="mongodb.madhudevops.online"

# Log file with timestamp
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

# Start message
echo "Script started executing at $TIMESTAMP" &>> $LOGFILE

# Validation function to check the success or failure of a command
VALIDATE() {
    if [ $1 -ne 0 ]; then
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

# Diable the nodejs module
dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "Disabled the nodejs module"

# Enabled the  nodejs:18 module
dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "Enabled the nodejs:18 module"

# Installe the nodejs
dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "Installed the nodejs:18 module"

id roboshop #if roboshop user does not exist, then it is failure
if [ $? -ne 0 ]; then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi

# Create the app folder
mkdir -p /app
VALIDATE $? "Created app directory"

# Download the application code to created app directory.
curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE
VALIDATE $? "Downloaded the cart code"

cd /app

# unzip the catalogue package
unzip -o /tmp/cart.zip &>> $LOGFILE
VALIDATE $? "Un-zipped cart package"

# Install the npm package
npm install &>> $LOGFILE
VALIDATE $? "Installed the npm package"

# Copy the catalouge service
cp /home/centos/aws-devops/roboshop-shell/cart.service /etc/systemd/system/ &>> $LOGFILE
VALIDATE $? "Copied the cart service"

#Start the service
systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "started the daemon-service"

#Enable the catalogue service
systemctl enable cart &>> $LOGFILE
VALIDATE $? "enabled the cart service"

# Start the catalogue service
systemctl start cart &>> $LOGFILE
VALIDATE $? "started the cart service"