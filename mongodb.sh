source common.sh

print_head "set of mongodb repository"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head "Installing mongodb"
yum install mongodb-org -y &>>${log_file}

print_head "enabling mongodb"
systemctl enable mongod &>>${log_file}

print_head "start mongodb service"
systemctl start mongod &>>${log_file}

systemctl restart mongod &>>${log_file}

#update /etc/mongodb.conf file from 127.0.0.1 with 0.0.0.0