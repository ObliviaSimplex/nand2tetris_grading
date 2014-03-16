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

cd working

for file in *; do
	cd $file
	
	for subfile in *; do
		if [ -d "$subfile" ]; then
			echo "> $file contains $subfile directory"
			find "$subfile" -name '*.hdl' -exec mv '{}' . \;
			find "$subfile" -name '*.asm' -exec mv '{}' . \;
			rm -rf "$subfile"
		fi
	done
	
	find . ! -name '*.hdl' ! -name '*.asm' -delete
	cp ../../$projectdir/* .

	cd ..
done

