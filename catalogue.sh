curl -sL https://rpm.nodesource.com/yum install nodejs -y
setup_lts.x | bash
useradd roboshop
mkdir /app
rm -rf /app/* #rerun should work
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip
cd /app
npm install
cp configs/catalogue.service /etc/systemd/system/catalogue.service

systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org-shell -y

mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js