my_optim <- function(ini_vals){
  source("drut_eval.R")
  out <- optim( 
    par = ini_vals,
    fn = eval_fun_mead,
    control = list(
      alpha = 0.01,
      beta = 0.005,
      gamma = 0.02
    )
  )
  print(out)
  write(c(out$par, out$value, out$convergence), "results/results.out")
}