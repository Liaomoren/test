#!/bin/bash
#Author: Garfield
#Date: 20240413
#Requirements: from 1~1000 if number's 7 multiples then additive numbers.
#type: while

sum=0

i=1

while (($i <= 1000))
do
    if ((i%7 == 0)); then
        sum=$((sum+i))
    fi
        ((i++))
done

echo "The sum of all multiples of 7 between 1 and 1000 is:$sum"
