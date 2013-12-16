library(monash)
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

########## REMOVE ##########
if(any(set.nonstacked == "RFY-BST2"))
{
        my.id <- which(set.nonstacked == "RFY-BST2")
        set.nonstacked[my.id] <- "BOOST"
}
###########################

my.gpars <- list(xaxt="n")
my.index <- seq(2,length(index.horizons),by=2)

pos.legend <- "bottomright";  my.lwd <- 1;

savepdf(paste(graph.folder, prefix.results,"-",prefix.merge,"-",DGP,"-",sdBase*100,"-non-stacked","-",prefix.pdf,sep=""), heigh = my.heigh, width = my.width)
par(mfrow = c(n.lengths,4))

limit.bias <- limit.variance <- limitmse <- limit.bv <- numeric(length(all.lengths))

for(T in all.lengths)
{
	file.required <- paste(wd.folder, prefix.merge,"-",DGP,"-",sdBase,"-",T,".Rdata",sep="")
	load(file.required);
		
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
	ts.plot(mse[index.horizons,,drop=F],col=c(color.nonstacked,color.mean),xlab="Horizon",ylab="Mean Squared Error (MSE)",main=paste("T = ",T,message,sep=""),lwd=my.lwd, gpars = my.gpars)	
	axis(1,at=my.index,labels=index.horizons[my.index])
		
	if(T == head(all.lengths,1))
	legend(pos.legend, legend=set.nonstacked,col=color.nonstacked,lwd=2)
	
	# PLOT BIAS^2
	if(any(set.nonstacked=="MEAN"))
	{
		ts.plot(BIAS[index.horizons,setdiff(id.nonstacked,id.mean),drop=F],col=color.nonstacked,xlab="Horizon",ylab="Bias",main=paste("T = ",T,sep=""),lwd=my.lwd, gpars = my.gpars)
		axis(1,at=my.index,labels=index.horizons[my.index])

		lines(BIAS[index.horizons,id.mean,drop=F],col=color.mean,lwd=my.lwd)
	}else{
		
		ts.plot(bias[index.horizons,,drop=F],col=color.nonstacked,xlab="Horizon",ylab=expression(paste(Bias^2)),main=paste("T = ",T,sep=""),lwd=my.lwd, gpars = my.gpars)
		axis(1,at=my.index,labels=index.horizons[my.index])
	}
	
	# PLOT VARIANCE
	ts.plot(variance[index.horizons,,drop=F],col=color.nonstacked,xlab="Horizon",ylab="Variance",main=paste("T = ",T,sep=""),lwd=my.lwd, gpars = my.gpars)
	axis(1,at=my.index,labels=index.horizons[my.index])

	# PLOT BIAS^2 + VARIANCE
	bv <- bias+variance
	ts.plot(bv[index.horizons,,drop=F],col=color.nonstacked,xlab="Horizon",ylab=expression(paste(Bias^2+Variance)),main=paste("T = ",T,sep=""),lwd=my.lwd, gpars = my.gpars)
	axis(1,at=my.index,labels=index.horizons[my.index])

}
dev.off();	
	
