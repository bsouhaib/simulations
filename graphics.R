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



strategies <- c("MEAN", 
"REC-LIN", "DIR-LIN", 
"REC-LINMIS","DIR-LINMIS",
"REC-KNN", "DIR-KNN", "RTI-KNN", "RFYMIS-KNN", "RFY-KNN",
"REC-MLP","DIR-MLP", "RFYMIS-MLP", "RFY-MLP",
"REC-BST2", "DIR-BST2", "RFYMIS-BST2", "RFY-BST2",
"AVG-LINMIS-LINMIS", "AVG-LIN-LIN", "AVG-MLP-MLP", "AVG-KNN-KNN", "AVG-BST2-BST2",
"AVG-LIN-KNN", "AVG-LIN-MLP", "AVG-LIN-BST2",
"AVG-LINMIS-KNN", "AVG-LINMIS-MLP", "AVG-LINMIS-BST2")

# "AVG-LIN-KNN", "AVG-LIN-MLP", "AVG-LIN-BST2"
# "AVG-LIN-LIN", "AVG-MLP-MLP", "AVG-KNN-KNN", "AVG-BST2-BST2"


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
prefix.merge <- "thesis"


source("graphics-MakeResults.R")

index.horizons <- seq(H);
	

if(DGP=="STAR"){
#index.horizons <- seq(11,20)		
	index.horizons <- seq(15)
}

do.stacked.boost <- F
make.graphics(c("REC-LIN","DIR-LIN", "REC-MLP", "DIR-MLP"), "OVERALL", TRUE)
make.graphics(c("REC-LIN", "REC-MLP", "REC-KNN", "REC-BST2"), "REC", TRUE)
make.graphics(c("DIR-LIN", "DIR-MLP", "DIR-KNN", "DIR-BST2"), "DIR", TRUE)

make.graphics(c("REC-LIN", "REC-MLP", "REC-KNN", "REC-BST2"), "REC")
make.graphics(c("DIR-LIN", "DIR-MLP", "DIR-KNN", "DIR-BST2"), "DIR")

do.stacked.boost <- T
make.graphics(c("REC-LIN", "REC-MLP", "REC-KNN", "REC-BST2"), "RECBIS", TRUE)
make.graphics(c("DIR-LIN", "DIR-MLP", "DIR-KNN", "DIR-BST2"), "DIRBIS", TRUE)


make.graphics(c("REC-LIN","DIR-LIN"), "LIN")
make.graphics(c("REC-LINMIS","DIR-LINMIS"), "LINMIS")
make.graphics(c("REC-LIN","DIR-LIN","REC-LINMIS","DIR-LINMIS"), "BOTHLIN")

make.graphics(c("REC-MLP","DIR-MLP", "REC-KNN", "DIR-KNN"), "NON-LIN")
#make.graphics(c("REC-KNN","DIR-KNN","REC-MLP","DIR-MLP", "REC-LIN", "DIR-LIN"), "NON-LIN2")
make.graphics(c("REC-MLP","DIR-MLP", "REC-LIN", "DIR-LIN"), "NON-LIN2")


make.graphics(c("REC-KNN", "RTI-KNN", "DIR-KNN"), "RTI")

	
## RFY-KNN
#make.graphics(c("REC-LIN","DIR-LIN","RFY-KNN", "RFY-BST2"), "RFY-LIN")
#make.graphics(c("REC-LINMIS","DIR-LINMIS","RFYMIS-KNN", "RFYMIS-BST2"), "RFY-LINMIS")

make.graphics(c("REC-LINMIS","DIR-LINMIS", "REC-LIN", "DIR-LIN", "RFY-KNN", "RFYMIS-KNN", "RFY-BST2", "RFYMIS-BST2"), "RFYwithMIS")
make.graphics(c("REC-LIN", "DIR-LIN", "RFY-KNN", "RFY-BST2"), "RFY")


#make.graphics(c("REC-LIN", "AVG-LIN-KNN", "AVG-LIN-BST2", "RFY-KNN", "RFY-BST2"), "RFY-AVG", TRUE)
#make.graphics(c("REC-LIN", "AVG-LIN-KNN", "AVG-LIN-BST2", "RFY-KNN", "RFY-BST2"), "RFY-AVG")

make.graphics(c("RFY-KNN", "RFYMIS-KNN", "RFY-BST2", "RFYMIS-BST2"), "RFYMIS-AVG", TRUE)


# NONLIN MODELS
make.graphics(c("REC-LIN", "DIR-LIN", "REC-MLP", "DIR-MLP", "REC-KNN","DIR-KNN","RFY-KNN"), "RFY-NONLIN-KNN")
make.graphics(c("REC-LIN", "DIR-LIN", "REC-MLP", "DIR-MLP", "REC-BST2","DIR-BST2","RFY-BST2"), "RFY-NONLIN-BST2")

make.graphics(c("REC-LIN", "DIR-LIN", "DIR-KNN", "DIR-MLP", "DIR-BST2", "RFY-KNN", "RFY-BST2"), "RFY-NONLIN")

#make.graphics(c("AVG-KNN-KNN", "AVG-LIN-KNN", "RFY-KNN", "AVG-BST2-BST2", "AVG-LIN-BST2", "RFY-BST2"), "RFY-AVG-NONLIN")
make.graphics(c("REC-LIN", "AVG-LIN-KNN", "RFY-KNN", "AVG-LIN-BST2", "RFY-BST2"), "RFY-AVG", TRUE)

make.graphics(c("REC-LIN", "AVG-LIN-KNN", "AVG-LIN-BST2", "AVG-KNN-KNN", "AVG-BST2-BST2", "RFY-KNN", "RFY-BST2"), "RFY-AVG")



#make.graphics(c("RFY-KNN","RFY-MLP","RFY-BST2"), "RFY-all")
##make.graphics(c("REC-LIN","REC-LINMIS", "RFY-KNN", "RFY-MLP", "RFY-BST2", "RFYMIS-KNN", "RFYMIS-MLP", "RFYMIS-BST2"), "RFY-MIS")
#make.graphics(c("AVG-LIN-LIN", "AVG-LIN-MLP", "RFY-MLP", "AVG-LIN-BST2", "RFY-BST2"), "RFY-AVGmodel2", TRUE)
#make.graphics(c("AVG-LIN-LIN", "AVG-LIN-MLP", "RFY-MLP", "AVG-LIN-BST2", "RFY-BST2"), "RFY-AVGmodel2")
#make.graphics(c("REC-LIN", "DIR-LIN", "REC-MLP","DIR-MLP","RFY-MLP"), "NONLIN-MLP")
#make.graphics(c("RFY-MLP", "AVG-MLP-MLP", "AVG-LIN-MLP"), "RFY-AVG-NONLIN-MLP")
#make.graphics(c("RFY-BST2", "AVG-BST2-BST2", "AVG-LIN-BST2"), "RFY-NONLIN-BST2")
#make.graphics(c("AVG-LINMIS-LINMIS", "AVG-LINMIS-KNN", "AVG-LINMIS-MLP", "AVG-LINMIS-BST2"), "RFY-AVGMIS", TRUE)
#make.graphics(c("REC-LIN","DIR-LIN","RFY-KNN"), "RFY-2")
#make.graphics(c("REC-MLP","DIR-MLP","RFY-KNN"), "RFY-3")
#make.graphics(c("REC-LINMIS","DIR-LINMIS","RFY-KNN"), "RFY-4")
#make.graphics(c("RFY-KNN", "RFYMIS-KNN"), "RFY-MIS")
#make.graphics(c("AVG-KNN-KNN","AVG-LIN-KNN", "RFY-KNN"), "RFYvsAVG1")
#make.graphics(c("AVG-KNN-KNN","AVG-LIN-KNN", "RFY-KNN"), "RFYvsAVG1", TRUE)
#make.graphics(c("REC-LIN", "DIR-KNN", "AVG-LIN-KNN", "RFY-KNN"), "RFYvsAVG2")
#make.graphics(c("REC-LIN", "DIR-KNN", "AVG-LIN-KNN", "RFY-KNN"), "RFYvsAVG2", TRUE)
## RFY-BST2
#make.graphics(c("RFY-KNN", "RFY-BST2"), "BOOST")
#make.graphics(c("RFYMIS-KNN", "RFYMIS-BST2"), "BOOST-MIS")
#make.graphics(c("REC-LIN", "DIR-BST2", "AVG-LIN-BST2", "RFY-BST2"), "RFY-1")








	
