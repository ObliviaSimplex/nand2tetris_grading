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

PROJECT_LIST=$(<$PROJECT_DIR/tests)

### Function definitions
grade_ASM() {
  ASM=$SCRIPT_DIR/$STUDENT_DIR/$ASM

  # Test if the file exists
  if [ ! -f "$ASM" ]; then
    echo -n ",0"
    ERR=$(echo -e "${ERR}<br \/>${TEST_SCRIPT}: ${ASM} not found");
    return
  fi

  # Attempt to assemble the .asm file into a .hack file
  result=$($TECS/Assembler.sh $ASM 2>&1)
  if [ ! "$result" == "" ]; then
    echo -n ",0"
    ERR=$(echo -e "${ERR}<br \/>${ASM}: Assembler.sh error")
    return
  fi

  # Run the test script
  result=$($TECS/CPUEmulator.sh $TEST_SCRIPT 2>&1)

  if [ "$result" == "End of script - Comparison ended successfully" ]; then
    echo -n ",1"
    CORRECT=$(expr $CORRECT + 1)
  else
    echo -n ",0"
    ERR=$(echo -e "${ERR}\n${TEST_SCRIPT}: $result")
  fi
}

clean_err() {
  ERR=$(echo "$ERR" | sed "s|$SCRIPT_DIR/$STUDENT_DIR\/||g" | sed 's/,/\&#44;/g' | sed ':a;N;$!ba;s/\n/<br \/>/g')
}

# echo student name
NAME=$(echo "$STUDENT_DIR" | sed 's:.*\/::g' | tr '_' ' ')
echo -n \"$NAME\"

CORRECT=0
ERR=""

for TEST_SCRIPT in $PROJECT_LIST; do
  TEST_SCRIPT=$SCRIPT_DIR/$STUDENT_DIR/$TEST_SCRIPT

  ASM=$(grep '^load.*hack,' "$TEST_SCRIPT" | sed 's/.* \(.*\)\.hack.*/\1.asm/');

  grade_ASM
done

clean_err
echo ",$CORRECT,\"$ERR\""
