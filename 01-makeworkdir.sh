#!/bin/bash

if [ $# != 1 ]; then
  echo "Usage: $0 <dir>"
  exit
fi

if [ -e working ]; then
  rm -rf working
fi

mkdir working

cd $1

for file in *; do
  studentname=$(echo $file | sed 's/_.*//')
  targetfile=$(echo $studentname | sed 's/ /_/g')
  ext=$(echo $file | sed 's/.*\.//')

  if [ -e ../working/$targetfile ]; then
    echo "Error: duplicate entry for $studentname - delete one entry and re-run script"
  else
    mkdir ../working/$targetfile
    if [ "$ext" == "zip" ]; then
      unzip -q "$file" -d ../working/$targetfile/
      if [ $? -ne 0 ]; then
        echo "Error: could not unzip $file"
      fi
    elif [ "$ext" == "rar" ]; then
      unrar x -inul "$file" ../working/$targetfile/
      if [ $? -ne 0 ]; then
        echo "Error: could not unrar $file"
      fi
    elif [ "$ext" == "7z" ]; then
      7z e "$file" -o../working/$targetfile/ >/dev/null
      if [ $? -ne 0 ]; then
        echo "Error: could not unrar $file"
      fi
    elif [ "$ext" == "hdl" ]; then
      chipline=$(cat "$file" | grep CHIP)
      if [ $? -ne 0 ]; then
        echo "Error: could not determine chip name of $file"
      else
        chipname=$(echo "$chipline" | sed 's/CHIP\s\+\(\w\+\).*/\1/')
        cp "$file" ../working/$targetfile/${chipname}.hdl
      fi
    elif [ "$ext" == "asm" ]; then
      asmname=$(cat "$file" | grep 'File name' | sed 's|.*/||')
      asmname=$asmname
      if [ "$asmname" != "" ]; then
        if [ `echo $asmname | grep '\.asm'` ]; then
          cp "$file" ../working/$targetfile/${asmname}
        else
          echo "Error: could not determine .asm name of $file"
        fi
      else
        echo "Error: could not determine .asm name of $file"
      fi
    elif [ "$ext" == "pdf" -o "$ext" == "doc" -o "$ext" == "docx" ]; then
      cp "$file" "../working/$targetfile/$targetfile.$ext"
    elif [ "$ext" == "java" ]; then
      classline=$(cat "$file" | grep 'class' | head -n1 | grep 'class') # for $?
      if [ $? -ne 0 ]; then
        echo "Error: could not determine classname of $file"
      else
        classname=$(echo "$classline" | sed 's/^.*class\s\+\(\w\+\).*$/\1/')
        cp "$file" ../working/$targetfile/${classname}.java
      fi
    else
      echo "Error: unknown file extension [$ext] - ignoring $file"
    fi
  fi
done

