#!/bin/bash

container_image="tomcat:latest"
container_name="tomcat"

sum=0

VM_Port=8000
Container_Port=8080

for((i=1;i<=10;i++))
do
    docker run -itd --restart=always --name ${container_name}_${i} -p $VM_Port:8080 $container_image
    ((VM_Port++))
done


