source common.sh

print_head "set of mongodb repository"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "Installing mongodb"
yum install mongodb-org -y &>>${log_file}
status_check $?

print_head "Upadte Mongodb listen Address"
sed -i -e 's/127.0.0.0/0.0.0.0/' /etc/mongod.conf &>>${log_file} # search for 127.0.0.0 and update with 0.0.0.0
status_check $?

print_head "enabling mongodb"
systemctl enable mongod &>>${log_file}
status_check $?

print_head "start mongodb service"
systemctl restart mongod &>>${log_file}
status_check $?

