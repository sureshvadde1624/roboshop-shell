source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then # -z checks var empty or not if empty it throws TRUE.
  echo -e "\e[31mMissing rabbitmq root password argument\e[0m"
  exit 1
fi

component=payment
python