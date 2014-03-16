#!/bin/bash

if [ $# != 1 ]; then
	echo "Usage: $0 <projectdir>"
	exit
fi

rm -rf working/*
./01-makeworkdir.sh download
./02-cleanfiles.sh $1
./03-evalproject.sh $1 | tee marks/$1.out.csv
cp marks/$1.out.csv marks/$1.marks.csv
./util-moodlerize.pl marks/$1.marks.csv > marks/$1.moodle.csv
