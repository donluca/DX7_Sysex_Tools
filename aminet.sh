#!/bin/bash

declare -i C
C=0
declare -i D
D=1
C_DIR=""

find . -type f -iname "*.syx" -execdir rm {} \;
find . -type f -iname ".*" -execdir rm {} \;

find . -type d -iname "*.DIR" -exec mv {} . \;

for f in `find . -type f -iname "*.tnm" | sort`
do
    DIRNAME="`dirname "${f}"`"
    printf -v j "%04d" $C
    mv "${f}" "${DIRNAME}"/"${j}".tnm
    mv "${f%.tnm}.ssx" "${DIRNAME}"/"${j}".ssx
    C+=1
done

find . -type f -iname "*.ssx" -execdir mv {} .. \;
find . -type f -iname "*.tnm" -execdir mv {} .. \;
find . -type d -iname "*.DIR" -execdir rm -rf {} \;
# find . -type d -iname "DIR*" -execdir rm -rf {} \;

C=0
for f in `find . -type f -iname "*.tnm" | sort`
do
    if [[ C -eq 0 || C -eq 32 ]]
    then
        d="`dirname "${f}"`"
        printf -v j "%03d" $D
        C_DIR="${d}"/"${1}""${j}".DIR
        mkdir "${C_DIR}"
        
        D+=1
        C=0
    fi
    mv "${f}" "${C_DIR}"/
    mv "${f%.tnm}.ssx" "${C_DIR}"/
    C+=1
done

find . -empty -type d -delete