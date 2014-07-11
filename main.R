rm(list=ls())
source(paste(Sys.getenv("HOME"),"/multistep/strategies.R",sep=""))
source(paste(Sys.getenv("HOME"),"/DATA/SIMULATIONS/simts.R",sep=""))


args=(commandArgs(TRUE))
if(length(args)==0){
	
#DGP<-"SUNSPOT" ; sdBase<-1; ntrain<-50; runstart<-1; runend<-5;
#DGP<-"STAR" ; sdBase<-0.05; ntrain<-50; runstart<-1; runend<-5;
	
	#folder<- "/u/sbentaie/simulations/temp/debug-"
	folder <- paste(Sys.getenv("HOME"),"/simulations/temp/test-debug-",sep="")
	#DGP <- "STAR" ; sdBase <- 0.1; ntrain <- 50; runstart <- 1; runend <- 1;
	
	DGP <- "MARCELO" ; sdBase <- 1; ntrain <- 50; runstart <- 1 ; runend <- 1;
	
}else{
    for(i in 1:length(args)){
		eval(parse(text=args[[i]]))
    }
}

set.runs <- seq(runstart,runend)

#strategies <- c("MEAN", "REC-LIN", "DIR-LIN",
#"REC-KNN", "RTI-KNN", "RJT-KNN", "RJT4-KNN",
#"DIR-KNN", "JNT-KNN", "JNT4-KNN", "RFY-KNN", 
#"REC-MLP", "DIR-MLP", "JNT-MLP", "JNT4-MLP", "RFY-MLP")
#strategies <- c("REC-BST1", "DIR-BST1", "RFY-BST1",
#"REC-BST2", "DIR-BST2", "RFY-BST2")

#strategies <- c("MEAN", "REC-LIN", "DIR-LIN",
#"REC-KNN",
#"DIR-KNN", "RFY-KNN",
#"REC-MLP", "DIR-MLP",
#"RFY-BST2")

#strategies <- c("MEAN", "REC-LIN", "REC-MLP", "DIR-MLP", "RFY-BST2")
#strategies <- c("REC-LIN","RFY-BST2")
#strategies <- c("MEAN","REC-LIN","REC-KNN")
#strategies <- c("MEAN", "REC-LIN", "DIR-LIN", "REC-KNN", "DIR-KNN")
#strategies <- c("REC-LINMIS", "DIR-LINMIS", "REC-MLP", "DIR-MLP")

#strategies <- c("REC-LIN", "DIR-LIN", "RTI-KNN")
#strategies <- c("REC-KNN", "DIR-KNN", "REC-MLP", "DIR-MLP")
# strategies <- c("MEAN","REC-LINMIS", "DIR-LINMIS", "RFY-KNN", "RFYMIS-KNN")
# strategies <- c("RFY-BST2", "RFYMIS-BST2")

#strategies <- c("REC-BST2","DIR-BST2")

#strategies <- c("RFY-MLP", "RFYMIS-MLP")

#strategies <- c("REC-BST2", "DIR-BST2", "RFY-BST2", "RFYMIS-BST2")

#strategies <- c("REC-MLP", "RTI-MLP", "DIR-MLP", "RJT-MLP", "RJTB1-MLP", "RJTB2-MLP", "", "",
#"DIR-MLP", "DJT-MLP", "DJTB1-MLP", "DJTB2-MLP")


############### MULTI-HORIZON  STRATEGIES #############
alls <- c(2,5)
rec.procedures <-  c("RTI",  paste("RJT", alls,  sep=""), "RJTL20", "RJTL11", "RJT")
dir.procedures <-  c("DIR"                              , "DJTL20", "DJTL11", "DJT")

strategies <- NULL

#strategies <- paste(dir.procedures,"-MLPmo", sep="")

allmodels <- c("MLP", "KNN")

for(model in allmodels){
	
	strategies <- c(strategies, paste(rec.procedures,"-", model, sep=""), paste(dir.procedures,"-", model, sep=""))
}
#######################################################




# if(DGP == "SUNSPOT")
# {
#  strategies <- c(strategies, "REC-LINMIS", "DIR-LINMIS", "RFYMIS-KNN","RFYMIS-MLP", "RFYMIS-BST2") 
# }

print(strategies)
print(DGP)
print(sdBase)


#################
#control <- strategy_control("cv", n.fold=5)
control <- strategy_control("ts-cv",train.percentage = 0.7, n.fold=5)

bst1 <- strategy_learner(name = "BST", interactions=1, nu = 0.3, max.mstop = 500)
bst2 <- strategy_learner(name = "BST", interactions=2, nu = 0.3, max.mstop = 500)
knn <-  strategy_learner(name = "KNN")
mlp <-  strategy_learner(name = "MLP", set.hidden = c(0,1,2,3,5), set.decay = c(0.005,0.01,0.05,0.1,0.2,0.3), nb.runs = 1, maxiter = 100, drop.linbias = F)
lin <-  strategy_learner(name = "MLP", set.hidden = 0, set.decay = 0, nb.runs = 1, drop.linbias = F)
#################

if(ntrain>150)
{
	knn <-  strategy_learner(name = "KNN", inc=4)	
	print("We have reduced the step for the neighbors ! ")
}

#################
datafile <- paste(Sys.getenv("HOME"),"/DATA/SIMULATIONS/testingData-",DGP,"-",sdBase,".Rdata",sep="")
load(datafile)
mycoef <- testingData$mycoef

#setEmbedBaseModel <- testingData$setEmbedBaseModel
#maxembed <- testingData$maxembed

set.embedding <- embeddings.base <- embeddings.rect <- c(1, testingData$setEmbed)

H <- testingData$H
Nbtest <- testingData$Nbtest
Xtest <- data.frame(testingData$Xtest)
colnames(Xtest) <- paste("X",seq(ncol(Xtest)),sep="")
#################


#################
forecasts.matrix <- array(NA,c(Nbtest, H , length(set.runs)))
all.forecasts <- vector("list",length(strategies))

for(i in seq_along(strategies)){
	istrategy <- strategies[i]
	if(grepl("RFY",istrategy)){
		all.forecasts[[i]] <- list(forecasts = forecasts.matrix, comp1 = forecasts.matrix, comp2 = forecasts.matrix)
	}else{
		all.forecasts[[i]] <- list(forecasts = forecasts.matrix, comp1 =  NULL, comp2 = NULL)
	}
}
#################

for(id.run in seq_along(set.runs))
{
	print(id.run)
	print(date())

	RUN <- set.runs[id.run]
	set.seed(RUN)
	
	trainset <- simts(sizeTimeSeries=ntrain,DGP=DGP,mycoef=mycoef,sdBase=sdBase)$series
	
	source(paste(Sys.getenv("HOME"),"/multistep/shared-main.R",sep=""))

}

print(" Writing files ...")
for(i in seq_along(strategies))
{
	istrategy <- strategies[i]
	file.name <- paste(folder, DGP , "-", sdBase , "-" , ntrain , "-" , runstart , "-" , runend , "-" , istrategy, ".Rdata", sep="")
	results <- all.forecasts[[i]]
	save(file = file.name, list=c("results"))
}

