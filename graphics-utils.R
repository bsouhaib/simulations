makeSuperposed<-function(datatable,maxy,colorvar,maintitle=NULL,xlab,ylab,do.plot=TRUE, densities = NULL)
{
	if(length(colorvar)!=ncol(datatable)-1)
    stop("Error color !")
	
	if(!is.null(densities) && length(densities) != ncol(datatable)-1 ){
		stop("Error densities ! ")
	}
	
#ylim<-c(0,1.1*max(maxy,apply(datatable[,-1],1,sum)))
	ylim<-c(0,maxy)
	xx <- c(datatable[,1], rev(datatable[,1]))
	
	if(do.plot){
		plot(x=datatable[,1], y=datatable[,2], ylim=ylim,type='l',ylab=ylab, xlab=xlab, main=maintitle)
	}
	
	a<-datatable[,2]
	yysrc2 <- c(rep(0, nrow(datatable)), rev(a))
	
	allvar <- seq(2,ncol(datatable))
	for(variable in allvar)
	{
		id <- which(variable==allvar)
		
		mydensity <- NULL
		if(!is.null(densities)){
			mydensity <- densities[id]
			if(is.na(mydensity))
			mydensity <- NULL
		}
		
		polygon(xx, yysrc2, col=colorvar[variable-1],border=NA, density = mydensity)
		if(variable != ncol(datatable))
		{
			b<-rev(apply(datatable[,2:(variable+1),drop=F],1,sum))
			yysrc2 <- c(a,b)
			a<-rev(b)
		}
	}
	
}

getid <- function(my.strategies)
{
	res <- NULL
	for(i in seq_along(my.strategies))
	{
		res <- c(res, which(my.strategies[i] == strategies) )
	}
	res
}

make.graphics <- function(strategies, name, stacked = FALSE)
{
	if(stacked)
	{
		id.stacked <<- getid(strategies)
		prefix.pdf <<- name
		source("graphics-StackedPlot.R")
		
	}else{
		id.nonstacked <<- getid(strategies)
		prefix.pdf <<- name
		source("graphics-DecompPlot.R")
	}
}

#methods<-c("MEAN",
#		   
#		   "REC-KNN","RTI-KNN","RJT-KNN","RSJT10-KNN","RSJT5-KNN","RSJT2-KNN","RJT2-KNN","RJT4-KNN",
#		   "DIR-KNN","JNT-KNN","SJNT10-KNN","SJNT5-KNN","SJNT2-KNN","JNT2-KNN","JNT4-KNN","RFY-KNN",
#		   
#		   "REC-MLP","DIR-MLP","JNT-MLP","SJNT10-MLP","SJNT5-MLP","SJNT2-MLP","JNT2-MLP","JNT4-MLP","RFY-MLP",
#		   
#		   "REC-BST1","DIR-BST1","RFY-BST1",
#		   
#		   "REC-BST2","DIR-BST2","RFY-BST2")

#	colormethods<-c("red",
#					"black","pink","orange","grey","brown","blue","blue","cyan",
#					"green","orange","blue","darkblue","grey","blue","brown","purple",
#					"black","green","orange","blue","darkblue","grey","blue","brown","purple",
#					"cyan","blue","magenta",
#					"orange","orange","orange")
