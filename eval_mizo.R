
eval_mizo <- function(dir){
  print("evaluating experiment")
  sim_dir <- paste0(dir,"/out")
  if(!dir.exists(sim_dir)){ stop(print(paste0(sim_dir, ' does not exist!')))}
  out_files <- list.files(path = sim_dir, pattern = "theta_tot")
  
  sim_0h <- read.table(paste0(sim_dir, "/", out_files[1]))
  sim_0h <- sim_0h[,3:2]
  sim_0h[,2] <- sim_0h[,2]-0.2
  colnames(sim_0h) <- c("total water content [-]", "depth [cm]")                      
  
  sim_12h <- read.table(paste0(sim_dir, "/", out_files[2]))
  sim_12h <- sim_12h[,3:2]
  colnames(sim_12h) <- c("total water content [-]", "depth [cm]")                      
  sim_12h[,2] <- sim_12h[,2]-0.2
  
  # 
  # sim_24h <- read.table(paste0(sim_dir, "/", out_files[3]))
  # sim_24h <- sim_24h[,3:2]
  # colnames(sim_24h) <- c("total water content [-]", "depth [cm]")                      
  # sim_24h[,2] <- sim_24h[,2]-0.2
  # 
  # sim_50h <- read.table(paste0(sim_dir, "/", out_files[4]))
  # sim_50h <- sim_50h[,3:2]
  # colnames(sim_50h) <- c("total water content [-]", "depth [cm]")                      
  # sim_50h[,2] <- sim_50h[,2]-0.2
  
  # dir to measured data
  meas_data <- "hansson2004_exp"
  
  data_0h <- read.table(paste0(meas_data, "/0h.dat"))
  colnames(data_0h) <- c("total water content [-]", "depth [cm]")                      
  
  data_12h <- read.table(paste0(meas_data, "/12h.dat"))
  colnames(data_12h) <- c("total water content [-]", "depth [cm]")   
  
  # data_24h <- read.table(paste0(meas_data, "/24h.dat"))
  # colnames(data_24h) <- c("total water content [-]", "depth [cm]")   
  # 
  # data_50h <- read.table(paste0(meas_data, "/50h.dat"))
  # colnames(data_50h) <- c("total water content [-]", "depth [cm]")   
  # 
  
  # 12 h
  if((length(data_12h$`depth [cm]`) == length(sim_12h$`depth [cm]`))&all(round(data_12h$`depth [cm]`, digits = 5) == round(sim_12h$`depth [cm]`, digits = 5))){
    
    # weighted MAE
    weights <- c(rep(1,13),4,1,4,rep(2,4))
    MAE <- sum(weights*abs(sim_12h$`total water content [-]`-data_12h$`total water content [-]`))/length(data_12h$`total water content [-]`)
    # MAE
    # MAE <- sum(abs(sim_12h$`total water content [-]`-data_12h$`total water content [-]`))/length(data_12h$`total water content [-]`)
    # MAE <- MAE+sum(abs(sim_24h$`total water content [-]`-data_24h$`total water content [-]`))/length(data_24h$`total water content [-]`)
    # MAE <- MAE+sum(abs(sim_50h$`total water content [-]`-data_50h$`total water content [-]`))/length(data_50h$`total water content [-]`)
    # Get the difference in minima
    dif_min <- abs(min(sim_12h$`total water content [-]`)-min(data_12h$`total water content [-]`))
    z_data <- data_12h$`depth [cm]`[14] 
    z_sim <- sim_12h$`depth [cm]`[which.min(sim_12h$`total water content [-]`)]
    z_dif<- abs(z_data - z_sim)
    MAE <- MAE + dif_min + z_dif
  }else{
    sim12h_interp <- approx(x = sim_12h$`depth [cm]`, y = sim_12h$`total water content [-]`, xout = data_12h$`depth [cm]`)
    # sim24h_interp <- approx(x = sim_24h$`depth [cm]`, y = sim_24h$`total water content [-]`, xout = data_24h$`depth [cm]`)
    # sim50h_interp <- approx(x = sim_50h$`depth [cm]`, y = sim_50h$`total water content [-]`, xout = data_50h$`depth [cm]`)
    # weighted MAE
    weights <- c(rep(1,13),4,1,4,rep(2,4))
    MAE <- sum(weights*abs(sim12h_interp$y-data_12h$`total water content [-]`))/length(data_12h$`total water content [-]`) 
    
    # Get the difference in minima
    dif_min <- abs(min(sim12h_interp$y)-min(data_12h$`total water content [-]`))
    z_data <- data_12h$`depth [cm]`[14]
    z_sim <- sim12h_interp$x[which.min(sim12h_interp$y)]
    z_dif<- abs(z_data - z_sim)
    MAE <- MAE + dif_min + z_dif
    # MAE
    # MAE <- sum(abs(sim12h_interp$y-data_12h$`total water content [-]`))/length(data_12h$`total water content [-]`)  
    # MAE <- MAE+sum(abs(sim24h_interp$y-data_24h$`total water content [-]`))/length(data_24h$`total water content [-]`)  
    # MAE <- MAE+sum(abs(sim50h_interp$y-data_50h$`total water content [-]`))/length(data_50h$`total water content [-]`)  
  }
  
  #file.remove(paste0(dir,"/occupied.out"))
  return(MAE)
}
