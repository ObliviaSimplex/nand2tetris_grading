#!/bin/bash

if [ $# != 1 ]; then
  echo "Usage: $0 <download_dir>"
  exit
fi

WORKING=working
rm -rf $WORKING/*

echo "Processing:"
for CUR_PATH in $1/*; do
  FILE_NAME=$(echo $CUR_PATH | sed 's/.*\///')
  echo "  $FILE_NAME"
  FILE_EXT=$(echo "$FILE_NAME" | sed 's/^.*\.//')
  STUDENT_DIR=$(echo "$FILE_NAME" | sed 's/_.*$//' | tr ' ' '_')

  mkdir -p $WORKING/$STUDENT_DIR

  if [ "$FILE_EXT" == "zip" ]; then
    unzip -j -qq -d "$WORKING/$STUDENT_DIR" "$CUR_PATH"
  elif [ "$FILE_EXT" == "rar" ]; then
    unrar e -inul "$CUR_PATH" "$WORKING/$STUDENT_DIR" 
  else
    OUTPUT_NAME=$(echo "$FILE_NAME" | sed 's/.*assignsubmission_file_//')
    cp "$CUR_PATH" "$WORKING/$STUDENT_DIR/$OUTPUT_NAME"
  fi
done
