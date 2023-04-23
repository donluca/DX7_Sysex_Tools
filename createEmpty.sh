#!/bin/bash

declare -i C
C=1
for d in `find . -type d -iname "*.DIR" | sort`
do
    for i in "${d}"/*.tnm
    do
        printf -v j "%02d" $C
        mv "${i}" `dirname "${i}"`/"${j}".tnm 
        mv "${i%.tnm}".ssx `dirname "${i}"`/"${j}".ssx
        C+=1
    done
    C=1
done

declare -i N

for d in `find . -type d -iname "*.DIR" | sort`
do
    N=`ls -1 "${d}"/*.tnm | wc -l`
    if [[ ! $N -eq 32 ]]
    then
        N+=1
        for (( c=$N; c<=32; c++ ))
        do
            printf -v j "%02d" $c
            # printf "INIT VOICE" > "${d}"/"${j}".tnm
            printf "EMPTY     " > "${d}"/"${j}".tnm
            cp -v ./empty.ssx "${d}"/"${j}".ssx
        done
    fi
done