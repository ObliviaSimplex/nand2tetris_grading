#!/bin/bash

asm=$1

if [ ! -f "$asm" ]; then
	echo "Error: '$asm' not found."
	exit 1
fi

if [[ -f "makefile" || -f "Makefile" ]]; then
	make -s clean
	make -s assemble 2>/dev/null
	if [ $? -ne 0 ]; then
		echo "Error in 'make assemble'"
		exit 2
	else
		cat "$asm" | ./assemble "$asm" > "${asm}.out"
	fi
elif [ -f "Assemble.java" ]; then
	javac Assemble.java 2>/dev/null
	if [ $? -ne 0 ]; then
		echo "Error compiling Assemble.java."
		exit 2
	else
		cat "$asm" | java Assemble "$asm" > "${asm}.out"
	fi
elif [ -f "assemble.c" ]; then
	gcc -o assemble assemble.c 2>/dev/null
	if [ $? -ne 0 ]; then
		echo "Error compiling assemble.c"
		exit 2
	else
		cat "$asm" | ./assemble "$asm" > "${asm}.out"
	fi
elif [ -f "assemble.cpp" ]; then
	g++ -o assemble assemble.cpp 2>/dev/null
	if [ $? -ne 0 ]; then
		echo "Error compiling assemble.cpp"
		exit 2
	else
		cat "$asm" | ./assemble "$asm" > "${asm}.out"
	fi
else
	echo "Error: could not find program files."
	exit 3
fi

diff -b "${asm}.hack" "${asm}.out" 1> /dev/null 2> /dev/null

if [ $? -eq 0 ]; then
	echo "Comparison successful"
	exit 0
else
	hack=$(echo "$asm" | sed 's/asm$/hack/')
	diff -b "${asm}.hack" "$hack" 1> /dev/null 2>/dev/null
	if [ $? -eq 0 ]; then
		echo "Comparison successful"
		exit 0
	else
		echo "Error: comparison failed"
		exit 4
	fi
fi

