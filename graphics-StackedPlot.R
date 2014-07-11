#library(monash)
###########################################
#STACKED PLOT
###########################################

set.stacked <- strategies[id.stacked]
id.mean <- which(strategies=="MEAN");

#savepdf(paste(graph.folder,prefix.results,"-",prefix.merge,"-",DGP,"-",sdBase*100,"-stacked","-",prefix.pdf,sep=""),heigh=my.heigh,width=my.width)
#pdf(paste(graph.folder,prefix.results,"-",prefix.merge,"-",DGP,"-",sdBase*100,"-stacked","-",prefix.pdf, ".pdf",sep=""),heigh=my.heigh,width=my.width)

savepdf( paste(graph.folder,prefix.results,"-",prefix.merge,"-",DGP,"-",sdBase*100,"-stacked","-",prefix.pdf, sep="") )

par(mfrow=c(n.lengths,length(set.stacked)))

veclimity <-numeric(length(all.lengths))

for(T in all.lengths)
{
	file.required <- paste(wd.folder,prefix.merge,"-",DGP,"-",sdBase,"-",T,".Rdata",sep="")
	load(file.required)
	
	
	### CUTTING #######
#MSE <- head(MSE,max(index.horizons)); BIAS <- head(BIAS,max(index.horizons)); 
#VARIANCE <- head(VARIANCE,max(index.horizons)); VARNOISE <- head(VARNOISE,max(index.horizons))
	
	id.length <- which(T == all.lengths)
	
	if(do.stacked.boost){
		limity<-max(BIAS[index.horizons,id.stacked]+VARIANCE[index.horizons,id.stacked],na.rm=T)
	}else{
		limity<-max(MSE[index.horizons,id.stacked],na.rm=T)
	}
	veclimity[id.length] <- limity
	
	for(j in seq_along(set.stacked))
	{
		istrategy <- set.stacked[j]
		i <- which(istrategy == strategies)
		
		if(do.stacked.boost)
		{
			my.doplot <- TRUE
			my.densities <- NULL

			if(grepl("RFY",istrategy) || grepl("AVG",istrategy))
			{
				datatable<-data.frame(cbind(index.horizons,VARDECOMP[index.horizons,i,1:2]))
				allcolors<-c("grey","orange")
				
				#makeSuperposed(datatable,maxy=1.1*ifelse(id.length<=2,veclimity[1],veclimity[1]),colorvar=allcolors,maintitle=paste("T = ",T," - ",istrategy,sep=""),xlab="Horizon",ylab="Error")
				makeSuperposed(datatable,maxy=1.1 * veclimity[id.length], colorvar=allcolors,maintitle=paste("T = ",T," - ",istrategy,sep=""),xlab="Horizon",ylab="Error")
				my.doplot <- FALSE
				my.densities <- c(40,40)
			}
			
			
			datatable <- data.frame(cbind(index.horizons,VARIANCE[index.horizons,i],BIAS[index.horizons,i]))
			
#allcolors <- c(ifelse(grepl("RFY",istrategy),"white","yellow"),"cyan")
allcolors <- c("yellow","cyan")

			
			makeSuperposed(datatable,
						   maxy=1.1 * veclimity[id.length],
						   colorvar=allcolors,maintitle=paste("T = ",T," - ",istrategy,sep=""),
						   xlab="Horizon",ylab="Error", 
						   do.plot=my.doplot,
						   densities = my.densities)
			
			
			
			
			lines(VARIANCE[index.horizons,i],col="red")
			lines(VARIANCE[index.horizons,i]+BIAS[index.horizons,i],col="black")
			
		}else{
			
			datatable <- data.frame(cbind(index.horizons,VARNOISE[index.horizons],BIAS[index.horizons,i],VARIANCE[index.horizons,i])); 
			
			#allcolors <- c("lightcyan","grey","yellow")
			allcolors <- c("lightcyan","cyan","yellow")

			makeSuperposed(datatable,maxy = 1.1*ifelse(id.length<=2,veclimity[1],veclimity[1])  ,colorvar=allcolors,maintitle=paste("T = ",T," - ",istrategy,sep=""),xlab="Horizon",ylab="Error")
			
			lines(MSE[index.horizons,id.mean],col="black",lwd=.3)
			
		}
	}		
}

#mtext("My 'Title' in a strange place", side = 3, line = -2, outer = TRUE)

#dev.off()	
endpdf();

