#!/bin/bash

function run_drutes {

  cd $1
  
  alpha=$2
  n=$3
  m=`echo "scale=12; 1.0-1.0/$n" | bc`
  Ks=$4
  imp=$5
  Csol=$6
  hc=$7
  #   substitution of parameters into input files for drutes 
  sed -e 's/!alpha/'$alpha'/g' -e 's/!n/'$n'/g' -e 's/!m/'$m'/g' -e 's/!Ksat/'$Ks'/g' -e 's/!imp/'$imp'/g' drutes.conf/freeze/freeze_min.conf > drutes.conf/freeze/freeze.conf
  sed -e 's/!Csolid/'$Csol'/g' -e 's/!hc/'$hc'/g' drutes.conf/freeze/freeze_heat_LTE_min.conf > drutes.conf/freeze/freeze_heat_LTE.conf
  
  bin/drutes > /dev/null
  echo 'process': $1 'done' > objfnc_wr.val
  cd ..
    
    
}


rm -f drutes.vals

#count the number of processes       
let nproc=0
while read l a b c d e f; do
    if [[  $l == "p"  ]]; then
      let nproc=nproc+1
    fi
  done < pars.in
  
#execute drutes function in parallel
let z=0
while read l a b c d e f
  do
    if [[  $l == "p"  ]]; then
      let z=z+1
      if [[ $z -lt $nproc ]] ; then
        run_drutes $z $a $b $c $d $e $f&
      else
        run_drutes $z $a $b $c $d $e $f
      fi
    fi
  done < pars.in
 

#at the end of drutes function file obj.val is created, if all files for each process exist then we have finished 
let z=0    
while [[ $z -lt $nproc ]]
  do
  let z=0
    for i in `seq 1 $nproc`
      do
        FILE="$i/objfnc_wr.val"
        if [ -f $FILE ];
          then
             let z=z+1
        fi
    done    
done

for i in `seq 1 $nproc` ; do
  val=`cat $i/objfnc_wr.val`
  echo $i $val >> drutes.vals
  rm $i/objfnc_wr.val
done
