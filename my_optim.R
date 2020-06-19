
my_optim <- function(ini_vals, alpha, beta, gamma, maxit, abstol){
  source("drut_eval.R")
  out <- optim( 
    par = ini_vals,
    fn = eval_fun_mead,
    control = list(
      alpha = alpha,
      beta = beta,
      gamma = gamma,
      maxit = maxit,
      abstol = abstol
    )
  )
  print(out)
  if(out$convergence != 0){
    print("something is fucked up!!!!!!")
  }
  write(c(out$par, out$value, out$counts[1], out$convergence), "results/results.out" )
}

my_optim_parallel <- function(ini_vals, alpha, beta, gamma, maxit, abstol, para, mins, maxs){
  source("drut_eval.R")
  library(optimParallel)
  max_core <- detectCores()-1
  if(max_core < para) para <- max_core
  cl <- makeCluster(para)     # set the number of processor cores
  setDefaultCluster(cl = cl) # set 'cl' as default cluster
  
  out <- optimParallel( 
    par = ini_vals,
    fn = eval_fun_mead_par,
    method = c("L-BFGS-B"),
    lower = mins,
    upper = maxs,
    control = list(
      alpha = alpha,
      beta = beta,
      gamma = gamma,
      maxit = maxit,
      abstol = abstol
    ),
    parallel = list(
      forward = FALSE
      
    )
  )
  print(out)
  if(out$convergence != 0){
    print("something is fucked up!!!!!!")
  }
  write(c(out$par, out$value, out$counts[1], out$convergence), "results/results.out" )
}