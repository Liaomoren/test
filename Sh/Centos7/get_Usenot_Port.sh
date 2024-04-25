#!/bin/bash
#Author: Garfield
#Date: 20240420
#Requirement:   Get not use Port.

###获取当前正在监听使用的端口           awk '{print $4}' >>>打印第四列  grep -o '[0-9]*' >>>删选单个字符包含0~9
listening_Ports=$(netstat -ntpl | grep 'LISTEN' | awk '{print $4}' | grep -o '[0-9]*')

###测试它读取出来的是不是当前正在占用的Port
#echo $listening_Ports

###定义端口的范围
start_Port=8080
end_Port=8100

echo "端口范围$start_Port ~ $end_Port 中有"
echo "###################################################"
for ((start_Port=8080;start_Port<=end_Port;start_Port++))
do
    ###从监听的端口中再次删选端口   -q不显示详情信息输出
    if echo "$listening_Ports" | grep -q "$start_Port"
    then
        used_Port=$start_Port
        echo "端口Port" $used_Port "已经被占用"
    else 
    ###这里面这些是没有被占用的Port
        usedN_Port=$start_Port
        echo "未被占用的Port" $usedN_Port    
    fi   
        
done
echo "###################################################"

