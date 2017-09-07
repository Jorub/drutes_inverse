
eval_fun= function(ln_id,obj=1){
  system2("./drut_opti.sh",wait=T)
  result=matrix(ncol=obj,nrow=ln_id)
  for(i in 1:ln_id){ 
    test=read.table(paste(i,"/out/objfnc.val",sep=''), quote="\"",comment.char="#", sep="",skip=1)
    result[i,1]=test$V1
    if(obj>1){
      result[i,2]=test$V2
    }
  }
  return(result)
}

