library(plotly)
library(plot3D)
library(data.table)
data_dir <- "D:/OwnCloud/drutes/results"

fnames<- list.files(pattern = "gen", path = data_dir)

data <- read.csv(paste0(data_dir,"/",fnames[1]))

for(file in fnames){
  data_tmp <-read.csv(paste0(data_dir,"/",file))
  data <- rbind(data, data_tmp)
}

data <- as.data.table(data)
data_new <- data[,"X":= NULL]

colnames(data_new) <- c("a", "b", "imp", "val")


data_filt <- data_new[val < 0.031]

data_filt_ext <- data_new[val < 0.0307]

plot_ly(x = data_new$a, y = data_new$b, z = data_new$imp, 
        type = "scatter3d", mode = "markers",
        color = data_new$val)


plot_ly(x = data_filt$a, y = data_filt$b, z = data_filt$imp, 
        type = "scatter3d", mode = "markers",
        color = data_filt$val)


lin_model <- lm(val ~ a + b + imp, data = data_filt)

lin_model2 <- lm(val ~ a + b + imp, data = data_new)

ggplot(data_filt[val < 5 ])+
  geom_point(aes(x = imp, y = b, color = a))
