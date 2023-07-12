source

mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then # -z checks var empty or not if empty it throws TRUE.
  echo -e "\e[31mMissing rabbitmq root password argument\e[0m"
  exit 1
fi

print_head "setup Erlang repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log_file}
status_check $?

print_head " setup rabbitmq repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log_file}
status_check $?

print_head " install Erlang and rabbitmq"
yum install rabbitmq-server earlang -y &>>${log_file}
status_check $?

print_head "enable rabbitmq service"
systemctl enable rabbitmq-server &>>${log_file}
status_check $?

print_head "start rabbitmq service"
systemctl restart rabbitmq-server &>>${log_file}
status_check $?

print_head "add application user"
rabbitmqctl list_users | grep roboshop &>>${log_file}
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop ${roboshop_app_password} &>>${log_file}
fi
status_check $?

print_head "configure permissions for application user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
status_check $?
