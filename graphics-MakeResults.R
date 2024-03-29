library(gtools)


print("Id of all strategies : ")
print( paste("(",seq_along(strategies),") ",strategies,sep="",collapse=" ** ") )

print(paste("DGP = ", DGP ," - sdBase ", sdBase,sep=""))
datafile<-paste(Sys.getenv("HOME"),"/DATA/SIMULATIONS/testingData-",DGP,"-",sdBase,".Rdata",sep="")
load(datafile)
stopifnot(sdBase==testingData$sdBase)

Xtest <- testingData$Xtest
Ytest <- testingData$Ytest
H <- testingData$H
Nbtest <- testingData$Nbtest


file<-paste(Sys.getenv("HOME"),"/DATA/SIMULATIONS/CONDEXPDATA/",prefix.cond,"-",DGP,"-",sdBase,".Rdata",sep="")
load(file)


NBTEST<-nrow(Xtest)
intervaltest <- seq(NBTEST)
max.bias <- min.bias <- max.variance <- min.variance <-0;

#all.decomposition <- vector("list", n.lengths)
#objdecomp <- list(bias = NULL, variance = NULL, vardecomp = NULL, covariance = NULL, noise = NULL, mse = NULL)
#for( i in seq(n.lengths)){
#all.decomposition[[i]] <- objdecomp
#}

vec <- vector("list", n.lengths)
all.decomposition <-list(bias=vec, variance = vec, vardecomp = vec, covariance = vec, noise = vec, mse = vec)

for(T in all.lengths){

	print("----------------------")	
	print(paste("T = ", T, sep=""))
	
	file.required <- paste(wd.folder, prefix.merge, "-", DGP , "-", sdBase,"-", T ,".Rdata",sep="")

	if(!file.exists(file.required) || do.it){
		
		start.runs <- seq(1, n.runs, by=step)
		MSE <- BIAS <- VARIANCE <- COVARIANCE <- matrix(NA, nrow=H,ncol=length(strategies))
		NOISE <- NULL
		VARDECOMP <- array(NA, c(H, length(strategies), 2))

		cmean<-allcondimean
		
		for(i in seq_along(strategies)){
			
			istrategy <- strategies[i]
			has.twocomp <- grepl("RFY",istrategy) | grepl("AVG",istrategy)
			
			print(istrategy)
			
			barm <- mvar <- mse <- big.barm <- big.ytest <- 0

			if(has.twocomp){
				n.comp <- 2
				id.comp <- c(2, 3)
								
				all.comb <- combinations(n.comp, 2)
				set.comb <- seq(nrow(all.comb))
				
				list.cov <- NULL
				list.barm <- list.mvar <- NULL
				
			}
			
			for(pass in c(1,2))
			{
				n.files <- 0
				for(start.run in start.runs)
				{
					end.run <- start.run + (step-1)
					
					
					file.name <- paste(results.folder, prefix.results, "-", DGP, "-", sdBase, "-", T, "-", start.run, "-", end.run,"-", istrategy, ".Rdata", sep="")

					################## For AVG ##################
					mysplit <- unlist(strsplit(istrategy,"-"))
					strat <- mysplit[1] 
					learner <- learner1 <- mysplit[2]
					is.avg <- (strat == "AVG")
					if(is.avg){
						learner2 <- mysplit[3]
						rec.strat <- paste("REC-",learner1,sep="")
						dir.strat <- paste("DIR-",learner2,sep="")
						
						rec.file <- paste(results.folder, prefix.results, "-", DGP, "-", sdBase, "-", T, "-", start.run, "-", end.run,"-", rec.strat, ".Rdata", sep="")
						dir.file <- paste(results.folder, prefix.results, "-", DGP, "-", sdBase, "-", T, "-", start.run, "-", end.run,"-", dir.strat, ".Rdata", sep="")
					}
					case1 <- (!is.avg && file.exists(file.name)) 
					case2 <- (is.avg && file.exists(rec.file) && file.exists(dir.file))
					#############################################
					
					if(case1 || case2)
					{
						if(case1){
							load(file.name)

						}else if(case2){
							load(rec.file)
							rec.results <- results
							load(dir.file)
							dir.results <- results
							
							results <- list(forecasts = NULL, comp1 = NULL, comp2 = NULL)
							results[[2]] <- rec.results[[1]]/2
							results[[3]] <- dir.results[[1]]/2
							results[[1]] <- results[[2]] + results[[3]]
						}
						
#if(istrategy =="AVG-KNN")
						
						RES <- results[[1]]
						
						
						if(has.twocomp)
						{
							RFYRES <- results[c(1,id.comp)]
						}
						
						if(pass==1)
						{
							if(has.twocomp)
							{
								all.barm <- lapply(RFYRES, apply, c(1,2), sum)
								list.barm <- if(is.null(list.barm)) all.barm else mapply("+", list.barm, all.barm, SIMPLIFY = FALSE)
								
								all.cov <- lapply(set.comb,
												  function(pass){
													  a <- all.comb[pass, 1]
													  b <- all.comb[pass, 2]
													  apply(RFYRES[[ id.comp[a] ]] * RFYRES[[ id.comp[b] ]], c(1,2), sum) 
												  } 
												  )
								list.cov <- if(is.null(list.cov)) all.cov else mapply("+",list.cov,all.cov,SIMPLIFY = FALSE)
							}
							
							barm <- barm + apply(RES, c(1,2), sum)
							
						}else if(pass==2)
						{
							
							if(has.twocomp)
							{
								myf <- function(RES,barm){  
									Reduce("+",lapply(seq(step),
													  function(elem){
													  apply((RES[, , elem]-barm)^2,2,sum)}
													  )
										   )  
								}
								all.mvar <- mapply(myf, RFYRES, list.barm, SIMPLIFY=FALSE)
								list.mvar <- if(is.null(list.mvar)) all.mvar else mapply("+", list.mvar, all.mvar, SIMPLIFY = FALSE)
							}
							
							mvar <- mvar + Reduce("+", lapply(seq(step),function(pass){apply((RES[, , pass] - barm)^2, 2, sum)}))
							mse  <- mse  + Reduce("+", lapply(seq(step),function(pass){apply((RES[, , pass] - Ytest)^2, 2, sum)}))
						}
						n.files <- n.files+1
						
					}# END FILE EXTIS
					
				} # END RUNS 
				
				if(pass==1)
				{
					barm <- barm/(n.files*step)
					
					if(has.twocomp)
					{
						list.barm <- lapply(list.barm ,"/", (n.files*step))
						list.cov  <- lapply(list.cov,  "/", (n.files*step))
					}
				}
			}# END ITEM 
			
			print(paste("n.files = ",n.files,sep=""))
			
			
			if(has.twocomp)
			{
				list.mvar <- lapply(list.mvar,"/", (n.files*step*Nbtest) )
				
				list.average <- lapply(set.comb,function(item){a <- all.comb[item,1]; b <- all.comb[item,2]; list.barm[[ id.comp[a] ]] * list.barm[[ id.comp[b] ]]  } )
				list.covfinal <- lapply(mapply("-",list.cov, list.average, SIMPLIFY=FALSE), function(item) {apply(item, 2, mean)})
				cov.final <- Reduce("+",list.covfinal)
				cov.final <- 2 * cov.final
			}
			
			mvar <- mvar/((n.files * step) * Nbtest)
			mse  <-  mse/((n.files * step) * Nbtest)
#estmse <- bias + variance + noise				
			
			
			BIAS[, i] <- apply((cmean-barm)^2,2,mean)
			VARIANCE[, i]  <- mvar
			MSE[, i]  <- mse
			
			if(has.twocomp)
			{
				VARDECOMP[, i, 1]<- list.mvar$comp1
				VARDECOMP[, i, 2]<- list.mvar$comp2
				COVARIANCE[, i] <- cov.final
			}
			
		} # END strategies
		
		allrfy <- grepl("RFY", strategies)
		idrfy  <- which(allrfy)
		
		if(any(allrfy)){
			stopifnot( all.equal(apply(VARDECOMP[,idrfy,,drop=F],c(1,2),sum) + COVARIANCE[,idrfy,drop=F],VARIANCE[,idrfy,drop=F]) )
		}
		
		VARNOISE <- apply((Ytest-cmean)^2, 2, mean)
		
		id.length <- which(T == all.lengths)
				
		all.decomposition$bias[[id.length]] <- t(BIAS)
		all.decomposition$variance[[id.length]]   <- t(VARIANCE)
		all.decomposition$vardecomp[[id.length]] <- VARDECOMP
		all.decomposition$covariance[[id.length]] <- t(COVARIANCE)
		all.decomposition$mse[[id.length]] <- t(MSE)	
		all.decomposition$noise[[id.length]] <- VARNOISE
		
		save(file=file.required, list=c("MSE","BIAS","VARIANCE","VARNOISE","VARDECOMP","COVARIANCE"))

		

	} # END file.required

} # END all.lengths

file.name <- paste(wd.folder , prefix.merge, "-", DGP, "-", sdBase, ".Rdata",sep="")
save(file = file.name,list=c("all.decomposition","strategies","color.strategies"))
