source common.sh

print_head "Configuring NodeJS Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head " Install NodeJS"
yum install nodejs -y &>>${log_file}
status_check $?

print_head "Creating Roboshop User"
id roboshop &>>${log_file}  #if user exist id command gives 0 as exit status.
if [ $? -ne 0 ]; then
  useradd roboshop &>>${log_file}
fi
status_check $?

print_head "Creating Application Directory"
if [ ! -d /app ]; then   #-d checks directory exist or not.
  mkdir /app &>>${log_file}
fi
status_check $?

print_head "Removing Old Content"
rm -rf /app/* &>>${log_file}
status_check $?

print_head "Downloading Catalogue Content"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
status_check $?
cd /app

print_head "Extracting Catalogue Content"
unzip /tmp/catalogue.zip &>>${log_file}
status_check $?

print_head "Installing NodeJS dependencies"
npm install &>>${log_file}
status_check $?

print_head "Copy SystemD service file"
cp ${code_dir}/configs/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}
status_check $?

print_head "Reload SystemD"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "Enable Catalogue Service"
systemctl enable catalogue &>>${log_file}
status_check $?

print_head "Start Catalogue Service"
systemctl restart catalogue &>>${log_file}
status_check $?

print_head "Copy mongodb repo file"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
status_check $?

print_head "Install mongo clint"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "load schema"
mongo --host mongodb.sureshdevops.online </app/schema/catalogue.js &>>${log_file}
status_check $?
