code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head() {
  echo -e "\e[35m$1\e[0m"
}

print_head "Installing nginx"
yum install nginx -y &>>${log_file}

print_head "Removing Old Content"
rm -rf /usr/share/nginx/html/* &>>${log_file}

print_head "Downloading Frontend Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}

print_head "Extrating Downloaded Frontend Content"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}

print_head "Coping nginx Config for Roboshop"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}

print_head "enabling nginx"
systemctl enable nginx &>>${log_file}

print_head "starting nginx"
systemctl restart nginx &>>${log_file}


# If any command is errored or failed, we need to stop the script.
# status of a command need to be printed.