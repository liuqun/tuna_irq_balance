#!/bin/bash

# Simple print cpu topology
# Original Author: kodango
# Debugged by: 刘群 <517067180@qq.com>

# 复制内核提供的 /proc/cpuinfo 文件到当前目录备用。
# 目的是防止cpuinfo文件含有超长的flags行打断bash的read方法。。。
cat /proc/cpuinfo > cpuinfo

function get_nr_processor()
{
    grep '^processor' cpuinfo | wc -l
}

function get_nr_socket()
{
    grep 'physical id' cpuinfo | awk -F: '{
            print $2 | "sort -un"}' | wc -l
}

function get_nr_siblings()
{
    grep 'siblings' cpuinfo | awk -F: '{
            print $2 | "sort -un"}'
}

function get_nr_cores_of_socket()
{
    grep 'cpu cores' cpuinfo | awk -F: '{
            print $2 | "sort -un"}'
}

echo '===== CPU Topology Table ====='
echo

echo '+--------------+---------+-----------+'
echo '| Processor ID | Core ID | Socket ID |'
echo '+--------------+---------+-----------+'

while read line; do
    if [ -z "$line" ]; then
        printf '| %-12s | %-7s | %-9s |\n' $p_id $c_id $s_id
        echo '+--------------+---------+-----------+'
        continue
    fi

    if echo "$line" | grep -q "^processor"; then
        p_id=`echo "$line" | awk -F: '{print $2}' | tr -d ' '` 
    fi

    if echo "$line" | grep -q "^core id"; then
        c_id=`echo "$line" | awk -F: '{print $2}' | tr -d ' '` 
    fi

    if echo "$line" | grep -q "^physical id"; then
        s_id=`echo "$line" | awk -F: '{print $2}' | tr -d ' '` 
    fi
done < cpuinfo

echo

awk -F: '{ 
    if ($1 ~ /processor/) {
        gsub(/ /,"",$2);
        p_id=$2;
    } else if ($1 ~ /physical id/){
        gsub(/ /,"",$2);
        s_id=$2;
        arr[s_id]=arr[s_id] " " p_id
    }
} 

END{
    for (i in arr) 
        printf "Socket %s:%s\n", i, arr[i];
}' cpuinfo

echo
echo '===== CPU Info Summary ====='
echo

nr_processor=`get_nr_processor`
echo "Logical processors: $nr_processor --- 逻辑核数"

nr_socket=`get_nr_socket`
echo "Physical socket: $nr_socket --- 主板CPU插座数量"

nr_siblings=`get_nr_siblings`
echo "Siblings in one socket: $nr_siblings  --- 每个CPU插座内的真实核数"

nr_cores=`get_nr_cores_of_socket`
echo "Cores in one socket: $nr_cores --- 每个CPU插座内的真实核数"

let nr_cores*=nr_socket
echo "Cores in total: $nr_cores --- 真实核数cores总计"

if [ "$nr_cores" = "$nr_processor" ]; then
    echo "Hyper-Threading: off (不开超线程)"
else
    echo "Hyper-Threading: on (开启超线程)"
fi

echo
echo '===== END ====='
