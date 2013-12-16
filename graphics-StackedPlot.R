###########################################
#STACKED PLOT
###########################################

set.stacked <- strategies[id.stacked]
id.mean <- which(strategies=="MEAN");

savepdf(paste(graph.folder,prefix.results,"-",prefix.merge,"-",DGP,"-",sdBase*100,"-stacked","-",prefix.pdf,sep=""),heigh=my.heigh,width=my.width)
par(mfrow=c(n.lengths,length(set.stacked)))

veclimity <-numeric(length(all.lengths))

for(T in all.lengths)
{
	file.required <- paste(wd.folder,prefix.merge,"-",DGP,"-",sdBase,"-",T,".Rdata",sep="")
	load(file.required)
	id.length <- which(T == all.lengths)
	
	if(do.stacked.boost){
		limity<-max(BIAS[,id.stacked]+VARIANCE[,id.stacked],na.rm=T)
	}else{
		limity<-max(MSE[,id.stacked],na.rm=T)
	}
	veclimity[id.length] <- limity
	
	for(j in seq_along(set.stacked))
	{
		istrategy <- set.stacked[j]
		i <- which(istrategy == strategies)
		
		if(do.stacked.boost)
		{
			datatable <- data.frame(cbind(seq(H),VARIANCE[,i],BIAS[,i])); allcolors <- c(ifelse(grepl("RFY",istrategy),"white","yellow"),"cyan");
			makeSuperposed(datatable,maxy=1.1*ifelse(id.length<=2,veclimity[1],veclimity[3]),colorvar=allcolors,maintitle=paste("T = ",T," - ",istrategy,sep=""),xlab="Horizon",ylab="Error")
			
			
			if(grepl("RFY",istrategy))
			{
				datatable<-data.frame(cbind(seq(H),VARDECOMP[,i,1:2]))
				allcolors<-c("yellow","orange")
				
				makeSuperposed(datatable,maxy=1.1*limity,colorvar=allcolors,maintitle=paste("T = ",T," - ",istrategy,sep=""),xlab="Horizon",ylab="Error",do.plot=FALSE)
			}
			
			lines(VARIANCE[,i],col="red")
			lines(VARIANCE[,i]+BIAS[,i],col="red")
			
		}else{
			
			datatable <- data.frame(cbind(seq(H),VARNOISE,BIAS[,i],VARIANCE[,i])); allcolors <- c("lightcyan","grey","yellow")
			makeSuperposed(datatable,maxy=1.1*limity,colorvar=allcolors,maintitle=paste("T = ",T," - ",istrategy,sep=""),xlab="Horizon",ylab="Error")
			
			lines(MSE[,id.mean],col="black",lwd=.3)
			
		}
	}		
}
dev.off()	
	
