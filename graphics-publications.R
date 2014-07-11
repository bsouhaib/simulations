rm(list=ls())
source("nicefigs.R")
source("graphics-utils.R")

#DGP <- "STAR"; sdBase <- 0.1
#DGP <- "MARCELO"; sdBase <- 1
DGP <- "SUNSPOT"; sdBase <- 1

#strategies <- c("MEAN","REC-KNN","DIR-KNN","RFY-KNN")
#color.strategies <- c("red", "black", "green", "purple")



strategies <- c("MEAN", "REC-LIN", "DIR-LIN", "AVG-LIN-LIN", "AVG-LIN-KNN",
"REC-KNN", "RTI-KNN", "RJT-KNN", "RJT4-KNN", "AVG-KNN-KNN",
"DIR-KNN", "JNT-KNN", "JNT4-KNN", "RFY-KNN", 
"REC-MLP", "DIR-MLP", "JNT-MLP", "JNT4-MLP", "RFY-MLP", "AVG-LIN-MLP", "AVG-MLP-MLP",
"REC-BST1", "DIR-BST1", "RFY-BST1", "AVG-LIN-BST1", "AVG-BST1-BST1",
"REC-BST2", "DIR-BST2", "RFY-BST2", "AVG-LIN-BST2", "AVG-BST2-BST2")

color.strategies <- c("red", "cyan", "cyan",
				"black","pink","orange","brown",
				"green","orange","brown", "purple",
				"black","green","orange","brown","purple",
				"black", "green", "purple",
				"black", "green", "purple")

#strategies <- c("MEAN", "REC-LIN", "DIR-LIN", "AVG-LIN-LIN", "AVG-LIN-KNN",
#"REC-KNN", "RTI-KNN", "RJT-KNN", "RJT4-KNN", "AVG-KNN-KNN",
#"DIR-KNN", "JNT-KNN", "JNT4-KNN", "RFY-KNN", 
#"REC-MLP", "DIR-MLP", "JNT-MLP", "JNT4-MLP", "RFY-MLP", "AVG-LIN-MLP", "AVG-MLP-MLP")

strategies <- c("MEAN", "REC-LIN", "DIR-LIN", 
"REC-KNN",
"DIR-KNN", "RFY-KNN",
"AVG-KNN-KNN","AVG-LIN-KNN")

color.strategies <- c("red", "cyan", "brown",
"black",
"green", "purple",
"orange", "pink")

#color.strategies <- rainbow(length(strategies))

different.colors <- F

all.lengths <- c(50, 100, 400)
#all.lengths <- c(50, 100)


n.lengths <- length(all.lengths)

my.heigh <- 29.7*(n.lengths/5)*0.8 
my.width <- 21*0.8;

wd.folder <- paste(Sys.getenv("HOME"),"/WDFOLDER/WORKINGDATA/",sep="")
results.folder <- paste(Sys.getenv("HOME"),"/WDFOLDER/RESULTS/",sep="")
graph.folder <- "./graphics/"

n.runs <- 2000
step <- 10
do.stacked.boost <- T
do.it <- T

prefix.cond <- "conditionalmean"

########### Graphics of RECTIFY paper ###########
if(TRUE){
	
	prefix.results <- "multistep"
	prefix.merge <- "ijfrectify"

	source("graphics-MakeResults.R")

	index.horizons <- seq(H);
	
#if(DGP=="STAR"){
#index.horizons <- seq(H)
#index.horizons <- seq(10)
#index.horizons <- seq(11,20)		
#}
if(DGP=="STAR"){	
	index.horizons <- seq(15)
}
	


	
######## New for RECTIFY ##########

	id.nonstacked <- getid(c("REC-KNN","DIR-KNN","RFY-KNN"))
        prefix.pdf <- "RFY-1"
        source("graphics-DecompPlot.R")

	id.nonstacked <- getid(c("REC-LIN","DIR-LIN","RFY-KNN"))
	prefix.pdf <- "RFY-2"
	source("graphics-DecompPlot.R")
	
	id.nonstacked <- getid(c("AVG-KNN-KNN","AVG-LIN-KNN", "RFY-KNN"))
	prefix.pdf <- "RFY-3"
	source("graphics-DecompPlot.R")
	
	id.stacked <- getid(c("AVG-KNN-KNN","AVG-LIN-KNN", "RFY-KNN"))
	prefix.pdf <- "RFY-4"
	source("graphics-StackedPlot.R")
	
	if(FALSE){
######## New for RECTIFY ##########
	id.nonstacked <- getid(c("REC-KNN","DIR-KNN","AVG-LIN-KNN", "RFY-KNN"))
	prefix.pdf <- "RFY-A"
	source("graphics-DecompPlot.R")
	
	id.nonstacked <- getid(c("REC-MLP","DIR-MLP","AVG-LIN-MLP", "RFY-MLP"))
	prefix.pdf <- "RFY-AA"
	source("graphics-DecompPlot.R")

	id.nonstacked <- getid(c("REC-KNN","DIR-KNN","REC-LIN", "RFY-KNN"))
	prefix.pdf <- "RFY-B"
	source("graphics-DecompPlot.R")

	id.stacked <- getid(c("REC-KNN","DIR-KNN","AVG-LIN-KNN", "RFY-KNN"))
	prefix.pdf <- "RFY-C"
	source("graphics-StackedPlot.R")
	
	id.stacked <- getid(c("REC-MLP","DIR-MLP","AVG-LIN-MLP", "RFY-MLP"))
	prefix.pdf <- "RFY-CC"
	source("graphics-StackedPlot.R")
	
	id.stacked <- getid(c("REC-LIN","DIR-LIN","AVG-LIN-LIN", "RFY-KNN"))
	prefix.pdf <- "RFY-D"
	source("graphics-StackedPlot.R")
	
	id.nonstacked <- getid(c("REC-KNN","DIR-KNN","RFY-KNN","REC-LIN","DIR-LIN"))
	prefix.pdf <- "RFY-E"
	source("graphics-DecompPlot.R")
	
	id.stacked <- getid(c("REC-KNN","DIR-KNN","RFY-KNN"))
	prefix.pdf <- "RFY-F"
	source("graphics-StackedPlot.R")

######## New for ICML ##########
	id.nonstacked <- getid(c("REC-MLP","DIR-MLP","REC-LIN", "RFY-BST2"))
	prefix.pdf <- "ICML-BOOST-3"
	source("graphics-DecompPlot.R")
	
	
################################

	
	id.nonstacked <- getid(c("REC-KNN","DIR-KNN","RTI-KNN", "RJT-KNN", "RJT4-KNN"))
	prefix.pdf <- "KNN-A"
	source("graphics-DecompPlot.R")
	
	id.nonstacked <- getid(c("DIR-KNN","JNT-KNN","JNT4-KNN"))
	prefix.pdf <- "KNN-B"
	source("graphics-DecompPlot.R")
	
	id.nonstacked <- getid(c("REC-MLP","DIR-MLP","JNT-MLP","JNT4-MLP"))
	prefix.pdf <- "MLP-A"
	source("graphics-DecompPlot.R")
	
	id.nonstacked <- getid(c("REC-MLP","DIR-MLP","RFY-BST2"))
	prefix.pdf <- "BOOST-vs-MLP-A"
	source("graphics-DecompPlot.R")
	
	id.nonstacked <- getid(c("REC-KNN","DIR-KNN","RFY-BST2"))
	prefix.pdf <- "BOOST-vs-KNN-B"
	source("graphics-DecompPlot.R")
	
	id.nonstacked <- getid(c("REC-MLP","REC-KNN","REC-LIN"))
	prefix.pdf <- "TEST-A"
	source("graphics-DecompPlot.R")
	
	id.nonstacked <- getid(c("DIR-MLP","DIR-KNN","DIR-LIN","RFY-KNN"))
	prefix.pdf <- "TEST-B"
	source("graphics-DecompPlot.R")	
	}
}

########### Graphics of IEEE TLNS paper ###########
if(FALSE){
	
	prefix.results <- "simulations"
	prefix.merge <- "ieeetnls"

	source("graphics-MakeResults.R")
	index.horizons <- seq(H);

	
	id.nonstacked <- getid(c("REC-KNN","DIR-KNN","RTI-KNN","RJT-KNN","RJT4-KNN"))
	prefix.pdf <- "KNN-A"
	source("graphics-DecompPlot.R")

	id.nonstacked <- getid(c("DIR-KNN","JNT-KNN","JNT4-KNN"))
	prefix.pdf <- "KNN-B"
	source("graphics-DecompPlot.R")

	id.nonstacked <- getid(c("REC-MLP","DIR-MLP","JNT-MLP","JNT4-MLP"))
	prefix.pdf <- "MLP-A"
	source("graphics-DecompPlot.R")
}

########### Graphics of ICML paper ###########
if(FALSE){

	prefix.results <- "simulations"
	prefix.merge <- "icml"
	
	idnonstacked<-getid(c("REC-MLP","DIR-MLP","RFY-BST2"))
	prefixPDF<-"0-BOOST-1"
	source("graphics-DecompPlot.R")
	
	idnonstacked<-getid(c("REC-KNN","DIR-KNN","RFY-BST2"))
	prefixPDF<-"0-BOOST-2"
	source("graphics-DecompPlot.R")
}
