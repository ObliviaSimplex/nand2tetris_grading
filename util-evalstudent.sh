#!/bin/bash

if [ $# != 2 ]; then
	echo "Usage: $0 <fname_lname> <projectdir>"
	exit
fi

studentdir=$1
if [ ! -d "working/$studentdir" ]; then
	echo "Student directory working/$studentdir not found."
	exit 1
fi

projectdir=$2
if [ ! -d "$projectdir" ]; then
	echo "Project directory $projectdir not found."
	exit 1
fi

torep="`pwd`/tecs/../working/"

cd $projectdir
projectlist=$(ls -1 *.tst)
cd ..
cd working

echo -n "\"Name\""
for testscript in $projectlist; do
	echo -n ",\"$testscript\""
done
echo ",\"total\",\"feedback\""

file="$studentdir"
cd $file
echo -n "\"$file\"" | sed 's/_/ /g'

correct=0
err=""


	for testscript in $projectlist; do
		hdl=$(cat "$testscript" | grep '^load.*hdl,' | sed 's/load \(.*\.hdl\).*/\1/')
		asm=$(cat "$testscript" | grep '^load.*hack,' | sed 's/.* \(.*\)\.hack.*/\1.asm/');
		hack=$(echo $asm | sed 's/\.asm/.hack/')

		if [ "$asm" != "" ]; then
			if [ ! -f "$asm" ]; then
				echo -n ",0"
				err=$(echo -e "${err}\n${testscript}: ${asm} not found");
			else
				# TECS doesn't have current-dir support for relative filenames :(
				result=$(../../tecs/Assembler.sh ../working/$file/$asm)
				if [ "$result" == "" ]; then
					# TECS also mangles the output filename and it ends up in tecs/.hack
					if [ -f "../../tecs/.hack" ]; then
						mv ../../tecs/.hack $hack
						result=$(../../tecs/CPUEmulator.sh ../working/$file/$testscript 2>&1)

						if [ "$result" == "End of script - Comparison ended successfully" ]; then
							echo -n ",1"
							correct=$(expr $correct + 1)
						else
							echo -n ",0"
							err=$(echo -e "${err}\n${testscript}: $result")
						fi
					else
						echo -n ",0"
						err=$(echo -e "${err}\n${asm}: Assembler.sh error")
					fi
				else
					echo -n ",0"
					err=$(echo -e "${err}\n${asm}: $result");
				fi
			fi
		elif [ ! -f "$hdl" ]; then
			echo -n ",0"
			err=$(echo -e "${err}\n${hdl}: not found")
		else
			# TECS doesn't have current-dir support for relative filenames :(
			result=$(../../tecs/HardwareSimulator.sh ../working/$file/$testscript 2>&1)
			if [ "$result" == "End of script - Comparison ended successfully" ]; then
				echo -n ",1"
				correct=$(expr $correct + 1)
			else
				echo -n ",0"
				err=$(echo -e "${err}\n${testscript}: $result")
			fi
		fi
	done
	
	
	
	
#for testscript in $projectlist; do
#	hdl=$(echo $testscript | sed 's/\.tst/.hdl/')
#	
#	if [ ! -f "$hdl" ]; then
#		echo -n ",0"
#		err=$(echo -e "${err}\n${hdl}: not found")
#	else
#		# TECS doesn't have current-dir support for relative filenames :(
#		result=$(../../tecs/HardwareSimulator.sh ../working/$file/$testscript 2>&1)
#		if [ "$result" == "End of script - Comparison ended successfully" ]; then
#			echo -n ",1"
#			correct=$(expr $correct + 1)
#		else
#			echo -n ",0"
#			err=$(echo -e "${err}\n${testscript}: $result")
#		fi
#	fi
#done



err=$(echo "$err" | sed "s|$torep||g")
echo ",$correct,\"$err\""
cd ..

