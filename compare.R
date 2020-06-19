#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# read and plot output with SHP

ln_args=length(args)


assign_args=T
if(ln_args>0){
  options(warn=-1)
  i=1
  while(assign_args){
    switch(args[i],
           "-name"={plotname=args[i+1];isNAplot=F},
           "-dir"={sim_dir=args[i+1];isNAleg=F},
           "-man"={readline("Manual:      -name - defines plotname 
                            -dir - directory with out data"); i=i-1
           },
           stop(paste("no valid argument, options are -name, -dir, -man. You entered:",args[i])))
    i=i+2
    if(i>ln_args){
      assign_args=F
    }
  }
}else{
  
  drutes_dirs <- list.files(pattern = "drutes")
  find_dir = T
  i = 1
  while(find_dir){
    if(dir.exists(paste0(drutes_dirs[i],"/out"))){
      sim_dir = paste0(drutes_dirs[i],"/out")
      plotname = drutes_dirs[i]
      find_dir = F
    }else{
      i = i +1
    }
    if(i > length(drutes_dirs)){
      stop("no drutes ourput directory found")
    }
  }
}

out_files <- list.files(path = sim_dir, pattern = "theta_tot")

print("reading simulated output")
print("0h")

sim_0h <- read.table(paste0(sim_dir, "/", out_files[1]))
sim_0h <- sim_0h[,3:2]
sim_0h[,2] <- sim_0h[,2]-0.2
colnames(sim_0h) <- c("total water content [-]", "depth [cm]")                      
print("12h")

sim_12h <- read.table(paste0(sim_dir, "/", out_files[2]))
sim_12h <- sim_12h[,3:2]
colnames(sim_12h) <- c("total water content [-]", "depth [cm]")                      
sim_12h[,2] <- sim_12h[,2]-0.2

print("24h")
sim_24h <- read.table(paste0(sim_dir, "/", out_files[3]))
sim_24h <- sim_24h[,3:2]
colnames(sim_24h) <- c("total water content [-]", "depth [cm]")                      
sim_24h[,2] <- sim_24h[,2]-0.2

print("50h")
sim_50h <- read.table(paste0(sim_dir, "/", out_files[4]))
sim_50h <- sim_50h[,3:2]
colnames(sim_50h) <- c("total water content [-]", "depth [cm]")                      
sim_50h[,2] <- sim_50h[,2]-0.2

# dir to measured data
meas_data <- "hansson2004_exp"
print("reading measured data")

data_0h <- read.table(paste0(meas_data, "/0h.dat"))
colnames(data_0h) <- c("total water content [-]", "depth [cm]")                      

data_12h <- read.table(paste0(meas_data, "/12h.dat"))
colnames(data_12h) <- c("total water content [-]", "depth [cm]")   

data_24h <- read.table(paste0(meas_data, "/24h.dat"))
colnames(data_24h) <- c("total water content [-]", "depth [cm]")   

data_50h <- read.table(paste0(meas_data, "/50h.dat"))
colnames(data_50h) <- c("total water content [-]", "depth [cm]")   

xlims <- c(0.25,0.5)
ylims <- c(-0.2, 0)
png(paste0(plotname,".png"), width = 1000, height = 1000)
par( cex = 2)
plot(data_0h, xlim = xlims, ylim = ylims, type = "b", col = "black", pch = 4, lwd = 2)
par(new = T)
plot(data_12h, xlim = xlims, ylim = ylims, type = "b", col = gray(0.3), pch = 6, lwd = 2,
     xlab = "", ylab = "", xaxt = "n", yaxt = "n")
par(new = T)
plot(data_24h, xlim = xlims, ylim = ylims, type = "b", col = gray(0.5), pch = 3, lwd = 2,
     xlab = "", ylab = "", xaxt = "n", yaxt = "n")
par(new = T)
plot(data_50h, xlim = xlims, ylim = ylims, type = "b", col = gray(0.7), pch = 1, lwd = 2,
     xlab = "", ylab = "", xaxt = "n", yaxt = "n")
par(new = T)
plot(sim_0h, xlim = xlims, ylim = ylims, type = "l", col = "royalblue4", lwd = 2,
     xlab = "", ylab = "", xaxt = "n", yaxt = "n")
par(new = T)
plot(sim_12h, xlim = xlims, ylim = ylims, type = "l", col ="royalblue3", lwd = 2,
     xlab = "", ylab = "", xaxt = "n", yaxt = "n")
par(new = T)
plot(sim_24h, xlim = xlims, ylim = ylims, type = "l", col = "royalblue1", lwd = 2,
     xlab = "", ylab = "", xaxt = "n", yaxt = "n")
par(new = T)
plot(sim_50h, xlim = xlims, ylim = ylims, type = "l", col = "skyblue1", lwd = 2,
     xlab = "", ylab = "", xaxt = "n", yaxt = "n")
leg.txt <- c("Measured 0 h", "Measured 12 h", "Measured 24 h", "Measured 50 h", "Sim 0 h", "Sim 12 h", "Sim 24 h", "Sim 50 h")
legend("bottomright", leg.txt, col = c("black", gray(0.3), gray(0.5), gray(0.7), "royalblue4", "royalblue3", "royalblue1", "skyblue1"),
       lty = c(rep(0,4),rep(1,4)), pch = c(4,6,3,1,NA,NA,NA,NA), lwd = 2)
dev.off()