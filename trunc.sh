#!/bin/bash

for f in `find . -type f -iname "*.syx" | sort`
do
	tail -c +7 "${f}" | head -c 4096 > "${f}"trunc
	mv "${f}"trunc "${f}"
done
