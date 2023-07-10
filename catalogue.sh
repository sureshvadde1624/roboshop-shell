source common.sh

print_head "Configuring NodeJS Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

print_head " Install NodeJS"
yum install nodejs -y &>>${log_file}

print_head "Creating Roboshop User"
useradd roboshop &>>${log_file}

print_head "Creating Application Directory"
mkdir /app &>>${log_file}

print_head "Removing Old Content"
rm -rf /app/* &>>${log_file}

print_head "Downloading Catalogue Content"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
cd /app

print_head "Extracting Catalogue Content"
unzip /tmp/catalogue.zip &>>${log_file}

print_head "Installing NodeJS dependencies"
npm install &>>${log_file}

print_head "Copy SystemD service file"
cp configs/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}

print_head "Reload SystemD"
systemctl daemon-reload &>>${log_file}

print_head "Enable Catalogue Service"
systemctl enable catalogue &>>${log_file}

print_head "Start Catalogue Service"
systemctl restart catalogue &>>${log_file}

print_head "Copy mongodb repo file"
cp configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}

print_head "Install mongo clint"
yum install mongodb-org-shell -y &>>${log_file}

print_head "load schema"
mongo --host mongodb.sureshdevops.online </app/schema/catalogue.js &>>${log_file}