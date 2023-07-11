code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head() {
  echo -e "\e[35m$1\e[0m"
}

status_check(){
  if [ $1 -eq 0 ]; then
    echo success
  else
    echo failure
    echo "read the log life ${log_file} for more information about error"
    exit 1
  fi
}

schema_setup(){
  if [ "${schema_type}" == "mongo" ]; then
    print_head "Copy mongodb repo file"
    cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
    status_check $?

    print_head "Install mongo clint"
    yum install mongodb-org-shell -y &>>${log_file}
    status_check $?

    print_head "load schema"
    mongo --host mongodb.sureshdevops.online </app/schema/${component}.js &>>${log_file}
    status_check $?
  fi
}

nodejs(){
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
  if [ ! -d /app ]; then   #-d checks directory exist or not. -d /app gives true if dir exist.
    mkdir /app &>>${log_file}
  fi
  status_check $?

  print_head "Removing Old Content"
  rm -rf /app/* &>>${log_file}
  status_check $?

  print_head "Downloading ${component} Content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
  status_check $?
  cd /app

  print_head "Extracting ${component} Content"
  unzip /tmp/${component}.zip &>>${log_file}
  status_check $?

  print_head "Installing NodeJS dependencies"
  npm install &>>${log_file}
  status_check $?

  print_head "Copy SystemD service file"
  cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
  status_check $?

  print_head "Reload SystemD"
  systemctl daemon-reload &>>${log_file}
  status_check $?

  print_head "Enable ${component} Service"
  systemctl enable ${component} &>>${log_file}
  status_check $?

  print_head "Start ${component} Service"
  systemctl restart ${component} &>>${log_file}
  status_check $?

  schema_setup
}