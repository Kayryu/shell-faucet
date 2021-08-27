#!/bin/bash

# read ip table
ips=()
li=0
while read line
do
  ips[$i]="$line"
  i=$((i+1))
done < ips.txt

cips=${#ips[@]}
echo $cips

password=123456
mission=/home/abm/mission.sh

function action() {
   # ssh copy file
   # bash $mission $1 $2 $3
   expect <<EOF
     spawn ssh $1 "bash $mission $2 /home/abm/mission.sh /home/abm/"
     expect {
       "(yes/no)" { send "yes\n"; exp_continue }
       "password:" { send "$password\n" }
     }
     expect eof
EOF
}


function fission() {
  local b=1

  while [ $b -lt $cips ]
  do
    local i=0
    while [ $i -lt $b ]
    do
        local j=$((i+b))

        echo $j

        if [ $j -ge $cips ]
        then
          break
        fi

        echo "copy files from ${ips[$i]} to ${ips[$j]}"
        action ${ips[$i]} ${ips[$j]}

        i=$((i+1))
    done
    b=$((b*2))
  done
}

fission