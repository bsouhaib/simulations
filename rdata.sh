#!/bin/bash

#DGP=SUNSPOT
#sdBase=1

DGP=STAR
sdBase=0.1

#DGP=NLAR3
#sdBase=1

#DGP=BIL
#sdBase=1

#DGP=MARCELO
#sdBase=1

echo " $DGP - $sdBase "

folder="/projects/mlg/sbentaie/strategies/RESDATA/"
prefix="multistep"
lowb=1
upb=100
by=10

allntrain=(50 100 400)

allstrat=("MEAN" "REC-LIN" "DIR-LIN"
"REC-KNN" "RTI-KNN" "RJT-KNN"  "RJT4-KNN"
"DIR-KNN" "JNT-KNN" "JNT4-KNN" "RFY-KNN"
"REC-MLP" "DIR-MLP" "JNT-MLP" "JNT4-MLP" "RFY-MLP"
"REC-BST1" "DIR-BST1" "RFY-BST1"
"REC-BST2" "DIR-BST2" "RFY-BST2")


for ntrain in "${allntrain[@]}"
do
	for strat in "${allstrat[@]}"
	do
			missing=0 
			for runstart in $(seq $lowb $by $upb) 
			do
				runend=$(($runstart+$by-1))
				file="$folder/$prefix-$DGP-$sdBase-$ntrain-$runstart-$runend-$strat.Rdata"
				
				if [ ! -f "$file" ]
				then
				    #echo "$file not found."
					missing=$(($missing+1))
				fi
			done

			if test $missing -ne 0
                        then
				echo "T= $ntrain - $strat -  $(($upb/$by - $missing))/$(($upb/$by))  - MISSING=$missing"	
			fi

#		echo "T= $ntrain - $strat -  $(($upb/$by - $missing))/$(($upb/$by))"
	done
	echo "---------"
done

#		echo "T= $ntrain :  $(($missing/${#allstrat[@]})) RUNS  missing"



