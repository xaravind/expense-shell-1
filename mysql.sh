#!/bin/bash

source ./common.sh

echo "please enter root password"
read -s mysql_root_password


check_root

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing my sql server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enabling my sql server"

systemctl start mysqld &>>$LOGFILE 
VALIDATE $? "starting my sql server"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "setting up root server"

#Below code will be useful for idempotent nature
mysql -h db.dopspractice.online -uroot -p${mysql_root_password} -e 'SHOW DATABASES;' &>>$LOGFILE
if [ $? -ne 0 ]
then
  mysql_secure_installation --set-root-pass {mysql_root_password}
  VALIDATE $? "Setting up root password"
else
  echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi

