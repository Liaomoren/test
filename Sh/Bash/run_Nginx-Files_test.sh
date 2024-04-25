#!/bin/bash
#Author: Garfield
#Date: 20240418
#Requirement: Run a container for nginx Files system.

Test_container_nginx_name="nginx_Test"
container_name="Filesystem"
dockerimage="nginx:latest"
IP_Port="1756"

#creation a folder for configuration files data and shared directories.
data_Dir="/Nginx_Data_Test"

if [ ! -d "$data_Dir" ]; then
    mkdir -p $data_Dir
fi

docker run -itd --name ${Test_container_nginx_name} ${dockerimage}

#添加一行 空复制nginx_Test容器中的/home目录 这个目录里是空的 防止下面几行文件复制出来存放位置不对
#docker cp ${Test_container_nginx_name}:/home $data_Dir
docker cp ${Test_container_nginx_name}:/etc/nginx $data_Dir
docker cp ${Test_container_nginx_name}:/usr/share/nginx/html $data_Dir
docker cp ${Test_container_nginx_name}:/var/log $data_Dir

docker stop ${Test_container_nginx_name}
docker rm -vf ${Test_container_nginx_name}

shareDir="${data_Dir}/shareFiles"
if [ ! -d "$shareDir" ]; then
    mkdir -p $shareDir
fi

if [ ! -f "${data_Dir}/nginx/nginx.conf" ]; then
    touch ${data_Dir}/nginx/nginx.conf
fi

tee ${data_Dir}/nginx/nginx.conf <<-'EOF'
user  root;
worker_processes  auto;

error_log  /var/log/nginx/error.log info;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    server {
        listen 80 default_server;
        listen [::]:80 default_server;
        server_name _;
        charset utf-8;
        root    /opt/shareFiles;                  # 文件存放目录
        autoindex on;

        # 下载
        location / {
            autoindex_format html;                # 首页格式为HTML
            autoindex_exact_size off;             # 文件大小自动换算
            autoindex_localtime on;               # 按照服务器时间显示文件时间

            default_type application/octet-stream;# 将当前目录中所有文件的默认MIME类型设置为
                                                # application/octet-stream

            if ($request_filename ~* ^.*?\.(txt|doc|pdf|rar|gz|zip|docx|exe|xlsx|ppt|pptx)$){
                # 当文件格式为上述格式时，将头字段属性Content-Disposition的值设置为"attachment"
                add_header Content-Disposition: 'attachment;';
            }
            sendfile on;                          # 开启零复制文件传输功能
            sendfile_max_chunk 1m;                # 每个sendfile调用的最大传输量为1MB
            tcp_nopush on;                        # 启用最小传输限制功能

    #       aio on;                               # 启用异步传输
            directio 5m;                          # 当文件大于5MB时以直接读取磁盘的方式读取文件
            directio_alignment 4096;              # 与磁盘的文件系统对齐
            output_buffers 4 32k;                 # 文件输出的缓冲区大小为128KB

    #       limit_rate 1m;                        # 限制下载速度为1MB
    #       limit_rate_after 2m;                  # 当客户端下载速度达到2MB时进入限速模式
            max_ranges 4096;                      # 客户端执行范围读取的最大值是4096B
            send_timeout 20s;                     # 客户端引发传输超时时间为20s
            postpone_output 2048;                 # 当缓冲区的数据达到2048B时再向客户端发送
            chunked_transfer_encoding on;         # 启用分块传输标识
        }
    }
}
EOF

docker run -itd --name ${container_name} -p ${IP_Port}:80 \
--restart=always \
-v ${data_Dir}/html:/usr/share/nginx/html \
-v ${data_Dir}/log:/var/log \
-v ${data_Dir}/nginx:/etc/nginx \
-v ${shareDir}:/opt/shareFiles \
${dockerimage}
