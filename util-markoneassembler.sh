#!/bin/bash

if [ $# != 2 ]; then
	echo "Usage: $0 <projectdir> <studentdir>"
	exit
fi

projectdir=$1
if [ ! -d "$projectdir" ]; then
	echo "Project directory $projectdir not found."
	exit 1
fi

torep="`pwd`/tecs/../working/"

cd $projectdir
projectlist=$(ls -1 *.asm)
cd ..
cd working/$2

echo -n "\"Name\""
for testscript in $projectlist; do
	echo -n ",\"$testscript\""
done
echo ",\"total\",\"feedback\""

pwd

#for file in *; do
	echo -n "\"$file\"" | sed 's/_/ /g'
	
	correct=0
	err=""

	for testscript in $projectlist; do
		result=$(../../util-oneassembler.sh $testscript)
		if [ "$result" == "Comparison successful" ]; then
			echo -n ",1"
			correct=$(expr $correct + 1)
		else
			echo -n ",0"
			err=$(echo -e "${err}\n${testscript}: $result")
		fi
	done
	err=$(echo "$err" | sed "s|$torep||g" | sed 's/,/\&#44;/g' | sed ':a;N;$!ba;s/\n/<br \/>/g')
	echo ",$correct,\"$err\""
	cd ..
#done

# ---- check submissions against class list for anything missing

cd ..
#list=$(tail -n+2 list.csv | awk -F, '{print $1 "_" $2}')

#for i in $list; do
#	if [ ! -e working/$i ]; then
#		sname=$(echo $i | sed 's/,//g' | sed 's/_/ /g')
#		echo -n "\"$sname\""
#		for testscript in $projectlist; do
#			echo -n ",0"
#		done
#		echo ",0,\"nothing submitted\""
#	fi
#done

