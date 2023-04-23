#!/bin/bash

declare -i C
C=0

for d in `find . -type d -iname "*.DIR" | sort`
do
    for i in "${d}"/*.tnm
    do
        if [[ `cat $i` == "EMPTY     " ]]
        then
            C+=1
        fi
    done
    if [[ $C > 0 ]]
    then
        echo "${d}" "has " "$C" " empty voices"
    fi
    C=0
done