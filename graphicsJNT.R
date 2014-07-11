rm(list=ls())
source("nicefigs.R")
source("graphics-utils.R")


args=(commandArgs(TRUE))
if(length(args)==0){

#DGP <- "STAR"; sdBase <- 0.1
#DGP <- "MARCELO"; sdBase <- 1
DGP <- "SUNSPOT"; sdBase <- 1


}else{
    
	id <- args[1]
	if(id == 1){
		DGP <- "SUNSPOT"; sdBase <- 1
	}else if(id == 2){
		DGP <- "MARCELO"; sdBase <- 1
	}else if(id==3){
		DGP <- "STAR"; sdBase <- 0.1
	}else{
		stop("this number is not correct !")
	}
	
		
#	for(i in 1:length(args)){
#                eval(parse(text=args[[i]]))
#    }
	
	
}


############
strategies <- NULL

alls <- c(2,5)
rec.procedures <-  c("RTI",  paste("RJT", alls,  sep=""), "RJTL20", "RJTL11", "RJT")
dir.procedures <-  c("DIR"                              , "DJTL20", "DJTL11", "DJT")

#strategies <- paste(dir.procedures,"-MLPmo", sep="")

allmodels <- c("MLP", "KNN")

for(model in allmodels){
	
	strategies <- c(strategies, paste(rec.procedures,"-", model, sep=""), paste(dir.procedures,"-", model, sep=""))
}
strategies <- c(strategies, "MEAN")
#############


color.strategies <- rainbow(length(strategies))

different.colors <- T

all.lengths <- c(50, 100,400)
#all.lengths <- 400

n.lengths <- length(all.lengths)

my.heigh <- 29.7*(n.lengths/5)*0.8 
my.width <- 21*0.8;

wd.folder <- paste(Sys.getenv("HOME"),"/WDFOLDER/WORKINGDATA/",sep="")
results.folder <- paste(Sys.getenv("HOME"),"/WDFOLDER/RESULTS/",sep="")
graph.folder <- "./graphics/"

n.runs <- 1000
step <- 10
do.it <- F

prefix.cond <- "conditionalmean"
prefix.results <- "multistep"
prefix.merge <- "thesisJNT"


source("graphics-MakeResults.R")

index.horizons <- seq(H);
	

if(DGP=="STAR"){
#index.horizons <- seq(11,20)		
	index.horizons <- seq(15)
}


make.graphics(c("REC-KNN", "RTI-KNN", "RJT2-KNN", "RJTL11-KNN", "RJT-KNN"), "R-KNN")
make.graphics(c("DIR-KNN",  "DJTL11-KNN", "DJT-KNN"), "D-KNN")

make.graphics(c("REC-MLP", "RTI-MLP", "RJT2-MLP", "RJTL11-MLP", "RJT-MLP"), "R-MLP")
make.graphics(c("DIR-MLP", "DJTL11-MLP", "DJT-MLP"), "D-MLP")

