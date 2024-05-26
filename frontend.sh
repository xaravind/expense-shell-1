#!/bin/bash

source ./common.sh

check_root


dnf install nginx -y  &>>$LOGFILE
VALIDATE $? "installing nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "enabling nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "cleaning directory"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "downloding frontend code"

cd /usr/share/nginx/html &>>$LOGFILE
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "extarcting frontend code" 

cp /home/ec2-user/expense-shell-1/expense.conf /etc/nginx/default.d/ &>>$LOGFILE
VALIDATE $? "copying expense.conf"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "restaring nginx"
