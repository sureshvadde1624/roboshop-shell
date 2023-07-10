code_dir=$(pwd)

echo -e "\e[35mInstalling nginx\e[0m"
yum install nginx -y

echo -e "\e[35mRemoving Old Content\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[35mDownloading Frontend Content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[35mExtrating Downloaded Frontend Content\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[35mCoping nginx Config for Roboshop\e[0m"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[35menabling nginx\e[0m"
systemctl enable nginx

echo -e "\e[35mstarting nginx\e[0m"
systemctl restart nginx

