#!/bin/bash

if [ $# != 1 ]; then
	echo "Usage: $0 <projectdir>"
	exit
fi

projectdir=$1
if [ ! -d "$projectdir" ]; then
	echo "Project directory $projectdir not found."
	exit 1
fi

torep="`pwd`/tecs/../working/"

cd $projectdir
projectlist=$(cat tests)
#projectlist=$(ls -1 *.tst)
cd ..
cd working

echo -n "\"Name\""
for testscript in $projectlist; do
	echo -n ",\"$testscript\""
done
echo ",\"total\",\"feedback\""

for file in *; do
	cd $file
	mkdir completed
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
			mv $hdl completed
		fi
	done
	err=$(echo "$err" | sed "s|$torep||g" | sed 's/,/\&#44;/g' | sed ':a;N;$!ba;s/\n/<br \/>/g')
	echo ",$correct,\"$err\""
	if [ -f completed ]; then
		mv completed/* .
		rmdir completed
	fi
	cd ..
done

# ---- check submissions against class list for anything missing

cd ..
list=$(tail -n+2 list.csv | awk -F, '{print $1 "_" $2}')

for i in $list; do
	if [ ! -e working/$i ]; then
		sname=$(echo $i | sed 's/,//g' | sed 's/_/ /g')
		echo -n "\"$sname\""
		for testscript in $projectlist; do
			echo -n ",0"
		done
		echo ",0,\"nothing submitted\""
	fi
done

