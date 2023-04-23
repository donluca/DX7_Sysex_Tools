#!/bin/bash

for d in `find . -type d -iname "*.DIR" | sort`
do
    for i in "${d}"/*.tnm
    do
        RES=`tr -d '[:print:]' < "${i}"`
        if (( $? > 0 ))
        then
            echo "$i" "Contain Non-ASCII"
            rm "${i}"
            rm "${i%.tnm}".ssx
        fi
        if [[ ! $RES == "" ]]
        then
            echo "$i" "Contain Non-ASCII"
            rm "${i}"
            rm "${i%.tnm}".ssx
        fi
        RES="`cat "${i}"`"
        if [[ "${RES}" == *[![:ascii:]]* || "${RES}" == "          " || ! `xxd -i "${i}" | grep 0x00` == "" ]]
        then
            echo "$i" "Contain Non-ASCII"
            rm "${i}"
            rm "${i%.tnm}".ssx
        fi
    done
done