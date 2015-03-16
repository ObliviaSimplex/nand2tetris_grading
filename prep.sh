#!/bin/bash

if [ $# != 1 ]; then
  echo "Usage: $0 <projectdir>"
  exit
fi

rm -rf working
mkdir -p working
mkdir -p marks
./01-makeworkdir.sh download
./02-cleanfiles.sh $1
