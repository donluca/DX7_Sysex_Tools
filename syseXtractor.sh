#!/bin/bash

for f in `find . -type f -iname "*.syx" | sort`
do
    FILENAME="`basename "${f}"`"
    g=`dirname "${f}"`/"${FILENAME}"
    DIRNAME="${g%.syx}.DIR"
    mkdir -v "${DIRNAME}"
    head -c 118 "${f}" > "${DIRNAME}/01.ssx"
    head -c 128 "${f}" | tail -c 10 > "${DIRNAME}/01.tnm"
    for i in {2..32}
    do
        printf -v j "%02d" $i
        head -c $((($i-1)*128+118)) "${f}" | tail -c 118 > "${DIRNAME}/$j.ssx"
        head -c $((($i-1)*128+128)) "${f}" | tail -c 10 > "${DIRNAME}/$j.tnm"
    done
    rm "${f}"
done
