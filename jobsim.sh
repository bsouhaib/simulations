#!/bin/bash

localfolder="$HOME/simulations"
wdfolder="$HOME/WDFOLDER/RESULTS"
outfolder="$HOME/WDFOLDER/OUT"
jobfolder="$localfolder/jobs"
rscript="main.R"

prefix=multistep

file="$jobfolder/simfile.job"
cat /dev/null > $file

DGP=STAR; sdBase=0.1
# DGP=MARCELO; sdBase=1
# DGP=SUNSPOT; sdBase=1

NOW=$(date +"%m-%d-%H-%M")

echo "$DGP - $sdBase"

for ntrain in 400 #100 #400 #50 100 400 #50 100 #200 400 #50 100 #200 400 
do
	for runstart in 101 111 121 661 671 681 781 791 801 811 821 #641 #$(seq 1 10 1000)    #$(seq 1 10 1000)  #$(seq 1001 10 2000)    #$(seq 1 10 100)  #$(seq 501 50 1000)
	do
	
	runend=$(($runstart+9))
	name=$prefix-$DGP-$sdBase-$ntrain-$runstart-$runend	
	
	echo "#!/bin/bash" > $file
	echo "#SBATCH --time=100:0" >> $file
	

	if [ "$ntrain" -eq "400" ]; then
		echo "#SBATCH --mem=8192" >> $file
	fi


	echo "#SBATCH -o $outfolder/$name.out" >> $file
	echo "#SBATCH -e $outfolder/$name.err" >> $file
	echo "#SBATCH --job-name=$DGP-$ntrain-$runstart-$runend" >> $file
	echo "module load R/3.0.1/gcc/4.7.0" >> $file		
	
	echo "cd $localfolder" >> $file 
	
		
	
	a="/usr/local/opt/R/3.0.1/gcc/4.7.0/bin/R  CMD BATCH --no-restore "
	b=" '--args DGP<-\""$DGP"\" sdBase<-$sdBase ntrain<-$ntrain runstart<-$runstart runend<-$runend "
	c="folder<-\""$wdfolder/$prefix-"\"' "
	d="$rscript "$outfolder/$name-$NOW.Rout" "
		
	echo "$a $b $c $d" >> $file	
	
	#read touche

	sbatch $file
	nbsubjobs=$(($nbsubjobs+1))	
	echo $nbsubjobs	
	done
done
