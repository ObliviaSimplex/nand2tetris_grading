#!/bin/bash

if [ $# != 1 ]; then
	echo "Usage: $0 <PROJECT_DIR>"
	exit
fi

PROJECT_DIR=$1
if [ ! -d "$PROJECT_DIR" ]; then
	echo "Project directory $PROJECT_DIR not found."
	exit 1
fi

PROJECT_LIST=$(<$PROJECT_DIR/tests)
echo -n "\"Name\""
for TEST_SCRIPT in $PROJECT_LIST; do
	echo -n ",\"$TEST_SCRIPT\""
done
echo ",\"total\",\"feedback\""

if [ "$PROJECT_DIR" == "4" ]; then
  SCRIPT=./util-evalassembly.sh
else
  SCRIPT=./util-evalhdl.sh
fi

for STUDENT_DIR in working/*; do
  $SCRIPT $PROJECT_DIR $STUDENT_DIR
done

# ---- check submissions against class list for anything missing

list=$(tail -n+2 list.csv | awk -F, '{print $1 "_" $2}')

for i in $list; do
  if [ ! -e working/$i ]; then
    sname=$(echo $i | sed 's/,//g' | sed 's/_/ /g')
    echo -n "\"$sname\""
    for TEST_SCRIPT in $PROJECT_LIST; do
      echo -n ",0"
    done
    echo ",0,\"nothing submitted\""
  fi
done

