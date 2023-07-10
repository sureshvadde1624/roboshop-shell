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
