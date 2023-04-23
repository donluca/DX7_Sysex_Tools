#!/bin/bash

for d in `find . -type d -iname "*.DIR" | sort`
do
    FILENAME="${d%.DIR}.syx"
    for i in "${d}"/*.tnm
    do
        cat "${i%.tnm}".ssx >> "${FILENAME}"
        cat $i >> "${FILENAME}"
    done
    rm -rf "${d}"
done