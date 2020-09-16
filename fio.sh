#!/bin/bash
# 
#
#Script to load system using fio
#Reports IOPS value and iostat output 
#
drive=$1
#bs=$2

iodevice=`df -h | grep -i $drive | awk '{print $1}'`
outdevice=`df -h | grep -i $drive | awk '{print $1}' | awk -F / '{print $3}'` 

echo $iodevice $outdevice

date

iostat -c -d -x -t -m  1 1000 > fio_writes_log.out&

sleep 10

for i in {1..3}; do time

#Cleanup not working well
#Test when using / as the drive value and
#test using embeded directory such as /datadrive/dir1

#Writes
fio --name=$drive/randwrite${i} --ioengine=libaio --iodepth=128 --rw=randwrite --bs=4k --direct=1 --size=512M --numjobs=1 --runtime=30 --group_reporting;rm -f $drive/randwrite${i}; done

sleep 10

#Kill the iostat process running on fio_report.out 
a=`ps -eaf | grep -i iostat|grep -v grep|awk '{print $2}'`;kill -9 $a



echo " "
echo " S T A R T I N G   R E A D AND W R I T E S "

#Reads and Writes
iostat -c -d -x -t -m  1 1000 > fio_readwrite_log.out&

sleep 10


for i in {1..3}; do time
#Readn and Write
fio --name=$drive/randrw${i} --ioengine=libaio --iodepth=128 --rw=randrw --bs=4k --direct=1 --size=512M --numjobs=1 --runtime=30 --group_reporting
rm -f $drive/randrw${i}*;done

sleep 10

date

#Kill the iostat process running on fio_report.out 
a=`ps -eaf | grep -i iostat|grep -v grep|awk '{print $2}'`;kill -9 $a

exit
