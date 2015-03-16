#!/bin/bash

list_file=list.csv

cat $list_file | tr -d '"' | tr ' ' '_' > $list_file.tmp

mv $list_file.tmp $list_file
