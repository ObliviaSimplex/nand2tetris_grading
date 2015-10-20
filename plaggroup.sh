#! /bin/bash

proj=$1
reportfile="plagreports/${proj}-plaggroups.txt"
numtasks=`ls $proj/*.tst | wc -l | tr -dc 0-9` 

BORDER="================================================================================"
for name in `cat plagreports/${proj}-plagsum.txt | cut -d"," -f2`; do
  echo $BORDER
  plist=`grep $name plagreports/plagreport-${proj}.txt | grep working | cut -d"/" -f2 | grep -o "[A-Z][a-z]*_[A-Z][a-z]* " | grep -v $name`
  pnum=`echo $plist | wc -w | tr -dc 0-9 `
  pscore=`grep $name plagreports/${proj}-plagsum.txt | cut -d, -f1`
  pquotient=`bc <<< "scale=2;$pscore / $pnum"`
  echo "Students who share copies with $name ($pscore / $pnum = $pquotient of $numtasks plagiarized)"
  echo $BORDER
  echo $plist | tr " " "\\n"
  echo
done > $reportfile

cat $reportfile
