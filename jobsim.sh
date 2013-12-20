#!/bin/bash

localfolder="$HOME/simulations"
wdfolder="/projects/mlg/sbentaie/strategies/RESDATA/"
outfolder="$WORKDIR/OUT"
jobfolder="jobs"
rscript="main.R"


prefix=multistep
#prefix=ICMLsim

simfile="$jobfolder/simfile.job"
cat /dev/null > $simfile

DGP=STAR
#DGP=MARCELO
#DGP=SUNSPOT

nbsubjobs=0

for sdBase in 0.1 #1 #0.1  
do
	for ntrain in 50 100 400 #50 100 400 #50 100 400 #50 100 #200 400 #50 100 #200 400 
	do
		for runstart in $(seq 1 10 100)  #$(seq 1001 10 2000)    #$(seq 1 10 100)  #$(seq 501 50 1000)
		do
			runend=$(($runstart+9))
			name=$prefix-$DGP-$sdBase-$ntrain-$runstart-$runend		
			
			a="/usr/local/opt/R/2.15.0/bin/R  CMD BATCH --no-restore "
			b=" '--args DGP<-\""$DGP"\" sdBase<-$sdBase ntrain<-$ntrain runstart<-$runstart runend<-$runend "
			c="folder<-\""$wdfolder/$prefix-"\"' "
			d="$rscript "$outfolder/$name.Rout" "
				
			echo "$a $b $c $d" >> $simfile	
			
			nbsubjobs=$(($nbsubjobs+1))	
			echo $nbsubjobs	
		done
	done
done

# PAUSE
read touche

name=$prefix-$DGP
file="$jobfolder/newfile.job"
echo "#!/bin/bash -l" > $file

echo "#PBS -t 1-$nbsubjobs" >> $file
echo "#PBS -l file=10gb" >> $file
echo "#PBS -l mem=10gb" >> $file
echo "#PBS -l nodes=1:ppn=1" >> $file
echo "#PBS -l walltime=50:00:00" >> $file
echo "cd $localfolder" >> $file 


# Execute the line matching the array index from file one_command_per_index.list:
echo "cmd=\`head -\${PBS_ARRAYID} $simfile | tail -1\`" >> $file


# Execute the command extracted from the file:
echo "eval \$cmd" >> $file

qsub   -M "bensouhaib@gmail.com" -N "$name" -o "$outfolder/$name.out" -e "$outfolder/$name.err"  $file

#methods<-strsplit(\""${methods[*]}"\",\" \")

