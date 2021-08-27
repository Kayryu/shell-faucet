#!/bin/bash

apt -y install expect  >> /dev/null

password=123456
host=$1
src_dir=$2
tar_dir=$3

expect <<EOF
 spawn scp -r $src_dir abm@$host:$tar_dir
  expect {
    "(yes/no)" { send "yes\n"; exp_continue }
    "password" { send "$password\n" }
    }
 expect "100%"
 expect eof
EOF