#!/bin/bash

#DGP=SUNSPOT sdBase=1

#DGP=STAR sdBase=0.1

#DGP=NLAR3 sdBase=1
#DGP=BIL sdBase=1

#DGP=MARCELO sdBase=1


allDGP=(SUNSPOT MARCELO STAR)
allSD=(1 1 0.1)

echo " $DGP - $sdBase "

folder="$HOME/WDFOLDER/RESULTS"
prefix="multistep"
lowb=1
upb=100
by=10

allntrain=(50 100 400)

allstrat=("MEAN" "REC-LIN" "DIR-LIN" 
"REC-LINMIS" "DIR-LINMIS" 
"REC-KNN"  "DIR-KNN" "RTI-KNN" "RFYMIS-KNN" "RFY-KNN"
"REC-MLP" "DIR-MLP" "RFYMIS-MLP" "RFY-MLP"
"REC-BST2" "DIR-BST2" "RFYMIS-BST2" "RFY-BST2")


#allstrat=("MEAN" "REC-LIN" "REC-MLP" "DIR-MLP" "RFY-BST2")
#allstrat=("MEAN" "REC-LIN" "DIR-LIN" "REC-LINMIS" "DIR-LINMIS" "REC-KNN" "DIR-KNN" "RTI-KNN" "RFY-KNN" "RFYMIS-KNN" "REC-MLP" "DIR-MLP" "RFY-MLP" "RFYMIS-MLP" "REC-BST2" "DIR-BST2" "RFY-BST2" "RFYMIS-BST2" "RJT-KNN")

#allstrat=("DJT-LIN")
#allstrat=("DJT-BST1")
#allstrat=("REC-BST2", "DIR-BST2")
#allstrat=("DJT-KNN")

i=0
for DGP in "${allDGP[@]}"
do

echo "----------"
echo "$DGP"
echo "----------"

sdBase=${allSD[$i]}
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
				echo -e "T= $ntrain - $strat -  $(($upb/$by - $missing))/$(($upb/$by))  - MISSING=\e[1;31m $missing \e[0m"
			fi

#		echo "T= $ntrain - $strat -  $(($upb/$by - $missing))/$(($upb/$by))"
	done
	echo "--"
done
i=$(($i+1))
done
#		echo "T= $ntrain :  $(($missing/${#allstrat[@]})) RUNS  missing"



