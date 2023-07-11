source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then # -z checks var empty or not if empty it throws TRUE.
  echo -e "\e[31mMissing mysql root password argument\e[0m"
  exit 1
fi

print_head "Desabling mysql 8 version"
yum module disable mysql -y &>>${log_file}
status_check $?

print_head ""
cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
status_check $?

print_head "installing mysql server"
yum install mysql-community-server -y &>>${log_file}
status_check $?

print_head "enable mysql service"
systemctl enable mysqld &>>${log_file}
status_check $?

print_head "start mysql service"
systemctl restart mysqld &>>${log_file}
status_check $?

print_head "set root password"
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}
status_check $?

print_head ""
mysql -uroot -pRoboShop@1 &>>${log_file}
status_check $?

