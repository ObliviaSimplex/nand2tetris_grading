#!/bin/bash

if [ $# != 1 ]; then
  echo "Usage: $0 <projectdir>"
  exit
fi

./util-moodlerize.pl marks/$1.marks.csv > marks/$1.moodle.csv
