#!/bin/bash

if [ $# != 1 ]; then
  echo "Usage: $0 <projectdir>"
  exit
fi

./prep.sh $1
./grade.sh $1
./moodlerize.sh $1
./plagseek.sh $1
./plaggroup.sh $1 
