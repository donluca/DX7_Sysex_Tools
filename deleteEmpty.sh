#!/bin/bash

for i in `find . -type f -iname "*.tnm" | sort`
do
    # if [[ `cat "${i}"` == "EMPTY     " ]]
    # then
    #     rm $i
    #     rm "${i%.tnm}".ssx
    # fi
    if [[ ! -e "${i%.tnm}".ssx ]]
    then
        rm $i
    fi
done

find . -type f -iname ".*" -execdir rm {} \;
find . -empty -type d -delete