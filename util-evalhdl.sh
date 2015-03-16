#!/bin/bash

if [ $# != 2 ]; then
	echo "Usage: $0 <PROJECT_DIR> <STUDENT_DIR>"
	exit
fi

PROJECT_DIR=$1
if [ ! -d "$PROJECT_DIR" ]; then
	echo "Project directory $PROJECT_DIR not found."
	exit 1
fi

STUDENT_DIR=$2
if [ ! -d "$STUDENT_DIR" ]; then
	echo "Student directory $STUDENT_DIR not found."
	exit 1
fi

### Constants
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TECS=$SCRIPT_DIR/tecs
BUILTINCHIPS=$TECS/builtInChips

PROJECT_LIST=$(<$PROJECT_DIR/tests)

grade_HDL() {
  # Test if the file exists
  if [ ! -f "$TO_TEST/$HDL" ]; then
    echo -n ",0"
    ERR=$(echo -e "${ERR}\n${HDL}: not found")
    return
  fi

  # Get the HDL file to test from the TO_TEST directory
  mv $TO_TEST/$HDL $STUDENT_DIR

  # Run the test script
  result=$($TECS/HardwareSimulator.sh $TEST_SCRIPT 2>&1)
  if [ "$result" == "End of script - Comparison ended successfully" ]; then
    echo -n ",1"
    CORRECT=$(expr $CORRECT + 1)
  else
    echo -n ",0"
    ERR=$(echo -e "${ERR}\n${TEST_SCRIPT}: $result")
  fi

  # Put the HDL file back into TO_TEST to ensure each HDL file is marked in isolation
  mv $STUDENT_DIR/$HDL $TO_TEST/$HDL
}

clean_err() {
  ERR=$(echo "$ERR" | sed "s|$SCRIPT_DIR/$STUDENT_DIR\/||g" | sed 's/,/\&#44;/g' | sed ':a;N;$!ba;s/\n/<br \/>/g')
}

# echo student name
NAME=$(echo "$STUDENT_DIR" | sed 's:.*\/::g' | tr '_' ' ')
echo -n \"$NAME\"

# Make directory for submitted files we will test
TO_TEST=$STUDENT_DIR/to_test
mkdir -p $TO_TEST

# Move submitted chips to TO_TEST directory
for TEST_SCRIPT in $PROJECT_LIST; do
  HDL=$(grep '^load.*hdl,' "$STUDENT_DIR/$TEST_SCRIPT" | sed 's/load \(.*\.hdl\).*/\1/')
  HDL=$STUDENT_DIR/$HDL
  if [ -f "$HDL" ]; then
    mv $HDL $TO_TEST
  fi
done

# Remove built-in chips from student's submission
for CHIP in `ls $BUILTINCHIPS`; do
  rm -f $STUDENT_DIR/$CHIP
done

CORRECT=0
ERR=""

for TEST_SCRIPT in $PROJECT_LIST; do
  TEST_SCRIPT=$SCRIPT_DIR/$STUDENT_DIR/$TEST_SCRIPT

  HDL=$(grep '^load.*hdl,' "$TEST_SCRIPT" | sed 's/load \(.*\.hdl\).*/\1/')

  grade_HDL
done

clean_err
echo ",$CORRECT,\"$ERR\""
