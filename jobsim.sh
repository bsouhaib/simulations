#!/bin/bash

localfolder="$HOME/simulations"
wdfolder="$HOME/WDFOLDER/RESULTS"
outfolder="$HOME/WDFOLDER/OUT"
jobfolder="$localfolder/jobs"
rscript="main.R"

prefix=multistep
tag="check"

file="$jobfolder/simfile.job"
cat /dev/null > $file

#DGP=STAR
#DGP=MARCELO
DGP=SUNSPOT

for sdBase in 1 #0.1 # 1  
do
	for ntrain in 50 100 400 #50 100 400 #50 100 #200 400 #50 100 #200 400 
	do
		for runstart in $(seq 1001 10 2000)  #$(seq 1001 10 2000)    #$(seq 1 10 100)  #$(seq 501 50 1000)
		do
		
		runend=$(($runstart+9))
		name=$prefix-$DGP-$sdBase-$ntrain-$runstart-$runend	
		
		echo "#!/bin/bash" > $file
		echo "#SBATCH --time=100:0" >> $file
		echo "#SBATCH -o $outfolder/$name.out" >> $file
		echo "#SBATCH -e $outfolder/$name.err" >> $file
		echo "#SBATCH --job-name=$name" >> $file
		echo "module load R/3.0.1/gcc/4.7.0" >> $file		
		
		echo "cd $localfolder" >> $file 
		
			
		
		a="/usr/local/opt/R/3.0.1/gcc/4.7.0/bin/R  CMD BATCH --no-restore "
		b=" '--args DGP<-\""$DGP"\" sdBase<-$sdBase ntrain<-$ntrain runstart<-$runstart runend<-$runend "
		c="folder<-\""$wdfolder/$prefix-"\"' "
		d="$rscript "$outfolder/$name$tag.Rout" "
			
		echo "$a $b $c $d" >> $file	
		
		#read touche

		sbatch $file
		nbsubjobs=$(($nbsubjobs+1))	
		echo $nbsubjobs	
		done
	done
done
