#!/bin/bash
#Author: Garfield
#Date: 20240418
#Requirement: 判断文件夹或文件是否存在是否存在，不存在则创建

Dir="/Test_Folder"

echo $Dir
if [  -d "$Dir" ]; then
   echo "---------$Dir is here---------"
else
    mkdir -p $Dir
    echo "---------$Dir is Creat---------"
fi

File="/Test_File"
echo $File
if [  -f "$File" ]; then
    echo "---------$File is here---------"
else
    touch $File
    echo "---------$File is Creat---------"
fi
