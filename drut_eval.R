source('eval_mizo.R')

eval_fun <- function(ln_id,obj=1){
  source('eval_mizo.R')
  
  system2("./drut_opti.sh",wait=T)
  result <- matrix(ncol=obj, nrow=ln_id)
  for(i in 1:ln_id){ 
    result[i,1] <- eval_mizo(paste0(i))
    if(obj>1){
      #result[i,2]=test$V1[2]
    }
  }
  return(result)
}

eval_fun_mead <- function(pars_in){
  source('eval_mizo.R')
  write(c("p", pars_in),'pars.in', ncol = length(pars_in)+1)
  system2("./drut_opti_meta.sh", wait=T)
  #obj.val <- read.table(paste("1/out/objfnc.val",sep=''), quote="\"", comment.char="#", sep="",skip=1)
  obj.val <- eval_mizo(paste0("1"))
  #result <- obj.val$V1[1]
  result <- obj.val
  return(result)
}

eval_fun_mead_par <- function(pars_in){
  source('eval_mizo.R')
  list_dirs <- list.dirs(recursive = F)
  freedir <- NA
  for(dir in list_dirs){
    if(file.exists(paste0(dir,"/occupied.out"))){
      
    }else{
      freedir <- dir
      break()
    }
  }
  if(is.na(freedir)){
    stop("Whoops, no free dir!")
  }
  write(c("p", freedir, pars_in), paste0(freedir,'/pars.in'), ncol = length(pars_in)+2)
  system(paste("./drut_opti.sh", paste0(strsplit(freedir, "/")[[1]][2],'/pars.in')), wait=T)
  #obj.val <- read.table(paste("1/out/objfnc.val",sep=''), quote="\"", comment.char="#", sep="",skip=1)
  obj.val <- eval_mizo(freedir)
  #result <- obj.val$V1[1]
  result <- obj.val
  print(result)
  return(result)
}
