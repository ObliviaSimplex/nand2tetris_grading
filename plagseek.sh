#! /bin/bash

# brutally iterates through every submission, and checks it for similarities
# against every other submission using diff. Not efficient, but effective. 

project=$1
sumfile=plagreports/${project}-plagsum.txt
rm $sumfile 2> /dev/null || touch $sumfile

checksuspect(){
  suspect=$1
  totalsims=0
  for student in working/*; do
    if [[ $suspect != $student ]]; then 
      sims=0
      for hdl in $suspect/to_test/*.hdl; do
        other=`echo $hdl | sed s:$suspect:$student:g`
        diff $hdl $other &> /dev/null && echo "==>> $hdl IS IDENTICAL TO $other " && sims=$(( $sims + 1 ))
      done
      (( $sims )) && echo -n "**** $sims similarit" && ( (( $sims > 1 )) && echo -n "ies" || echo -n "y" ) && echo " between $suspect and $student "
    fi
    totalsims=$(( $sims + $totalsims ))
  done
  (( $totalsims )) && echo && echo "TOTAL # OF SIMILARITIES FOR $suspect: $totalsims" \
    && echo "$totalsims,`echo $suspect | cut -d'/' -f2`" >> $sumfile
  return $totalsims
}

mainloop(){
  for submission in working/*; do
    echo
    echo "|=-----=[  Checking $submission ..."
    checksuspect $submission 
  done
}

mainloop | tee plagreports/plagreport-${project}.txt

echo
cat $sumfile | sort -nr > ${sumfile}-tmp
mv ${sumfile}-tmp $sumfile 

corfile=plagreports/${project}-plagsum-marks.txt

for row in `cat $sumfile`; do 
  echo $row >> $corfile
  grep `echo $row | cut -d"," -f2` marks/$project.moodle.csv >> $corfile
  echo >> $corfile
done

cat $corfile
