#!/bin/bash

declare -i count
count=1

for f in `find . -type f -iname "*.syx" | sort`
do
	printf -v j "%05d" $count
	DIRNAME=`dirname "${f:2}"`
	FILENAME=`basename "${f:2}"`
	mv -v "${f:2}" "${DIRNAME}"/"$j"_"${FILENAME}"
	count+=1
done
