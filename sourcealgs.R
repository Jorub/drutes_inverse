source('mo_PSO.R')
source('pso.R')
source('tlbo.R')

callopti=function(alg, pop, complexes 
                  ,mins, maxs
                  ,gen ,optimum=0 ,conv ,conv_gen
                  ,para
                  ,minimize=T
                  ,reini_prop,red_fac
                  ,output){
  
  # check if alg option exist
  alg_opts=c(1:8,21)
  if(!any(alg==alg_opts)){
    stop('This algorithm option is invalid. Choose 1-8 for single objective optimization and 21 for biobjective optimization')
  }
  
  # set-up parallel computation
  system(paste('./opti_setup.sh', para))
  
  dim=length(mins)
  switch(output,
         "all"=return(printall=T),
         "gbest"=return(printall=F)
        )
  
  # select algorithm
  switch(as.character(alg),
         "1"=return(PSO_all(pop,complexes=1,dim,mins,maxs,gen,printall=T,maxeval=para,start_shuffle_prob=reini_prop,red_fac=red_fac,optimum,conv,conv_gen,minimize,bn=F,sce=F)),
         "2"=return(PSO_all(pop,complexes=1,dim,mins,maxs,gen,printall=T,maxeval=para,start_shuffle_prob=reini_prop,red_fac=red_fac,optimum,conv,conv_gen,minimize,bn=T,sce=F)),
         "3"=return(PSO_all(pop,complexes,dim,mins,maxs,gen,printall=T,maxeval=para,start_shuffle_prob=reini_prop,red_fac=red_fac,optimum,conv,conv_gen,minimize,bn=F,sce=T)),
         "4"=return(PSO_all(pop,complexes,dim,mins,maxs,gen,printall=T,maxeval=para,start_shuffle_prob=reini_prop,red_fac=red_fac,optimum,conv,conv_gen,minimize,bn=T,sce=T)),
         "5"=return(TLBO_all(pop,complexes=1,dim,mins,maxs,gen,printall=T,maxeval=para,start_shuffle_prob=reini_prop,red_fac=red_fac,optimum,conv,conv_gen,minimize,bn=F,sce=F)),
         "6"=return(TLBO_all(pop,complexes=1,dim,mins,maxs,gen,printall=T,maxeval=para,start_shuffle_prob=reini_prop,red_fac=red_fac,optimum,conv,conv_gen,minimize,bn=T,sce=F)),
         "7"=return(TLBO_all(pop,complexes,dim,mins,maxs,gen,printall=T,maxeval=para,start_shuffle_prob=reini_prop,red_fac=red_fac,optimum,conv,conv_gen,minimize,bn=F,sce=T)),
         "8"=return(TLBO_all(pop,complexes,dim,mins,maxs,gen,printall=T,maxeval=para,start_shuffle_prob=reini_prop,red_fac=red_fac,optimum,conv,conv_gen,minimize,bn=T,sce=T)),
         "21"=return(PSO_all(pop,complexes=1,dim,mins,maxs,gen,printall=T,maxeval=para,start_shuffle_prob=reini_prop,red_fac=red_fac,minimize))
      )
}
