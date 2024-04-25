#!/bin/bash

container_name="tomcat_"

have=`docker ps -a | grep tomcat | docker ps -a --format '{{.Names}}'`

values_count=$(echo "$have"| wc -w)

#echo $values_count

while (($values_count != 0))
do
    if (($values_count != 0)); then
        docker stop $have
        docker rm -vf $have
        echo "Delete container>>>"${have}
    fi
        break
done

