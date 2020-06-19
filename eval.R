
sim_dir = "out"
out_files <- list.files(path = sim_dir, pattern = "theta_tot")


sim_0h <- read.table(paste0(sim_dir, "/", out_files[1]))
sim_0h <- sim_0h[,3:2]
sim_0h[,2] <- sim_0h[,2]-0.2
colnames(sim_0h) <- c("total water content [-]", "depth [cm]")                      


sim_12h <- read.table(paste0(sim_dir, "/", out_files[2]))
sim_12h <- sim_12h[,3:2]
colnames(sim_12h) <- c("total water content [-]", "depth [cm]")                      
sim_12h[,2] <- sim_12h[,2]-0.2

sim_24h <- read.table(paste0(sim_dir, "/", out_files[3]))
sim_24h <- sim_24h[,3:2]
colnames(sim_24h) <- c("total water content [-]", "depth [cm]")                      
sim_24h[,2] <- sim_24h[,2]-0.2

sim_50h <- read.table(paste0(sim_dir, "/", out_files[4]))
sim_50h <- sim_50h[,3:2]
colnames(sim_50h) <- c("total water content [-]", "depth [cm]")                      
sim_50h[,2] <- sim_50h[,2]-0.2

# dir to measured data
meas_data <- "hansson2004_exp"

data_0h <- read.table(paste0(meas_data, "/0h.dat"))
colnames(data_0h) <- c("total water content [-]", "depth [cm]")                      

data_12h <- read.table(paste0(meas_data, "/12h.dat"))
colnames(data_12h) <- c("total water content [-]", "depth [cm]")   

data_24h <- read.table(paste0(meas_data, "/24h.dat"))
colnames(data_24h) <- c("total water content [-]", "depth [cm]")   

data_50h <- read.table(paste0(meas_data, "/50h.dat"))
colnames(data_50h) <- c("total water content [-]", "depth [cm]")   


# 12 h
if((length(data_12h$`depth [cm]`) == length(sim_12h$`depth [cm]`))&all(round(data_12h$`depth [cm]`, digits = 5) == round(sim_12h$`depth [cm]`, digits = 5))){
  MAE <- sum(abs(sim_12h$`total water content [-]`-data_12h$`total water content [-]`))/length(data_12h$`total water content [-]`)
  MAE <- MAE+sum(abs(sim_24h$`total water content [-]`-data_24h$`total water content [-]`))/length(data_24h$`total water content [-]`)
  MAE <- MAE+sum(abs(sim_50h$`total water content [-]`-data_50h$`total water content [-]`))/length(data_50h$`total water content [-]`)
  
}else{
  sim12h_interp <- approx(x = sim_12h$`depth [cm]`, y = sim_12h$`total water content [-]`, xout = data_12h$`depth [cm]`)
  sim24h_interp <- approx(x = sim_24h$`depth [cm]`, y = sim_24h$`total water content [-]`, xout = data_24h$`depth [cm]`)
  sim50h_interp <- approx(x = sim_50h$`depth [cm]`, y = sim_50h$`total water content [-]`, xout = data_50h$`depth [cm]`)
  
  MAE <- sum(abs(sim12h_interp$y-data_12h$`total water content [-]`))/length(data_12h$`total water content [-]`)  
  MAE <- MAE+sum(abs(sim24h_interp$y-data_24h$`total water content [-]`))/length(data_24h$`total water content [-]`)  
  MAE <- MAE+sum(abs(sim50h_interp$y-data_50h$`total water content [-]`))/length(data_50h$`total water content [-]`)  
}




write.table(MAE, "MAE.txt", row.names = F, col.names = F)
