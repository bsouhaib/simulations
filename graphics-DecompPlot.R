#library(monash)
###########################################
#DECOMPOSITION PLOT
###########################################

set.nonstacked <- strategies[id.nonstacked]

color.nonstacked <- NULL;
for(id in seq_along(set.nonstacked))
{
	item <- which(set.nonstacked[id]== strategies)
	color.nonstacked <- c(color.nonstacked,color.strategies[item]);
}
id.mean <- which(strategies == "MEAN")
color.mean <- color.strategies[id.mean]

if(different.colors)
color.nonstacked <- rainbow(length(set.nonstacked))

########## REPLACE LONG NAMES ##########
if(FALSE){

oldnames <- c("RFY-BST2", "AVG-LIN-KNN", "AVG-KNN-KNN")
newnames <- c("BOOST", "AVG-L-K", "AVG-K-K")
for(iname in seq_along(oldnames)){
	if(any(set.nonstacked == oldnames[iname])){
		my.id <- which(set.nonstacked == oldnames[iname])
		set.nonstacked[my.id] <- newnames[iname]
	}
}

}
###########################

my.gpars <- list(xaxt="n")
my.index <- seq(2,length(index.horizons),by=2)

pos.legend <- "bottomright";  my.lwd <- 0.5;

#savepdf(paste(graph.folder, prefix.results,"-",prefix.merge,"-",DGP,"-",sdBase*100,"-non-stacked","-",prefix.pdf,sep=""), heigh = my.heigh, width = my.width)
#pdf(paste(graph.folder, prefix.results,"-",prefix.merge,"-",DGP,"-",sdBase*100,"-non-stacked","-",prefix.pdf,".pdf",sep=""), heigh = my.heigh, width = my.width)

savepdf( paste(graph.folder, prefix.results,"-",prefix.merge,"-",DGP,"-",sdBase*100,"-non-stacked","-",prefix.pdf,sep="") )
par(mfrow = c(n.lengths,4))

limit.bias <- limit.variance <- limitmse <- limit.bv <- numeric(length(all.lengths))

for(T in all.lengths)
{
	file.required <- paste(wd.folder, prefix.merge,"-",DGP,"-",sdBase,"-",T,".Rdata",sep="")
	load(file.required);
	
	### CUTTING #######
	MSE <- head(MSE,max(index.horizons)); BIAS <- head(BIAS,max(index.horizons)); 
	VARIANCE <- head(VARIANCE,max(index.horizons)); VARNOISE <- head(VARNOISE,max(index.horizons))
		
	bias <- BIAS[,id.nonstacked]
	variance <- VARIANCE[,id.nonstacked]
	mse <- MSE[,c(id.nonstacked,id.mean)]
	noise <- VARNOISE
			
	id.length <- which(T==all.lengths)
	limit.bias[id.length] <- max(BIAS[,setdiff(id.nonstacked,id.mean)],na.rm=T) 
	limit.variance[id.length] <- max(VARIANCE[,setdiff(id.nonstacked,id.mean)],na.rm=T) 
	limitmse[id.length] <- max(MSE[,id.nonstacked],na.rm=T);
	limit.bv[id.length] <- max(BIAS[ , setdiff(id.nonstacked,id.mean)] + VARIANCE[ , setdiff(id.nonstacked,id.mean)],na.rm=T);
	
	message<-""
	
	
	# PLOT MSE
	ts.plot(mse[index.horizons,,drop=F],col=c(color.nonstacked,color.mean),xlab="Horizon",ylab="MSE",main=paste("T = ",T,message,sep=""),lwd=my.lwd, gpars = my.gpars, ylim = c(0, limitmse[1]))	
	lines(noise, col="grey", lwd = 0.2)

	axis(1,at=my.index,labels=index.horizons[my.index])
		
	if(T == head(all.lengths,1))
	legend(pos.legend, legend=set.nonstacked,col=color.nonstacked,lwd=2, cex=0.5, pt.cex = 1)
	
	# PLOT BIAS^2
	if(any(set.nonstacked=="MEAN"))
	{
		ts.plot(BIAS[index.horizons,setdiff(id.nonstacked,id.mean),drop=F],col=color.nonstacked,xlab="Horizon",ylab="Bias",main=paste("T = ",T,sep=""),lwd=my.lwd, gpars = my.gpars)
		axis(1,at=my.index,labels=index.horizons[my.index])

		lines(BIAS[index.horizons,id.mean,drop=F],col=color.mean,lwd=my.lwd)
	}else{
		
		ts.plot(bias[index.horizons,,drop=F],col=color.nonstacked,xlab="Horizon",ylab=expression(paste(Bias^2)),main=paste("T = ",T,sep=""),lwd=my.lwd, gpars = my.gpars, 
		ylim = c(0, ifelse(T>100, limit.bias[id.length], limit.bias[id.length]))   )
		
		axis(1,at=my.index,labels=index.horizons[my.index])
	}
	
	# PLOT VARIANCE
	ts.plot(variance[index.horizons,,drop=F],col=color.nonstacked,xlab="Horizon",ylab="Variance",main=paste("T = ",T,sep=""),lwd=my.lwd, gpars = my.gpars,
	ylim = c(0, ifelse(T>100, limit.variance[id.length], limit.variance[id.length])) )
	
	axis(1,at=my.index,labels=index.horizons[my.index])

	# PLOT BIAS^2 + VARIANCE
	bv <- bias+variance
	#ts.plot(bv[index.horizons,,drop=F],col=color.nonstacked,xlab="Horizon",ylab=expression(paste(Bias^2+Variance)),main=paste("T = ",T,sep=""),lwd=my.lwd, gpars = my.gpars)

	ts.plot(bv[index.horizons,,drop=F],col=color.nonstacked,xlab="Horizon",ylab=expression(paste(Bias^2+Variance)),main=paste("T = ",T,sep=""),lwd=my.lwd, gpars = my.gpars,
	ylim = c(0, ifelse(T>100, limit.bv[id.length], limit.bv[id.length])) )
	
	axis(1,at=my.index,labels=index.horizons[my.index])

}

#dev.off();	
endpdf();	

