library(ggplot2)
library(gridExtra)

trainer1 = data.frame(
    Performance = c(0,0,0,0,  4,5,6,7,  6,6,7,8,  8,7,9,10,  9,7,9,12),
    Stage = rep(0:4, each = 4),
    Horse = as.character(rep(1:4, 5)),
    Trainer = rep(1, 20)
)

trainer2 = data.frame(
    Performance = c(0,0,0,0,0,0,0,0,  3,3.5,4,4.5,5,5.5,6,6.5,  6,6.5,7.5,7,  9.5,9,  12),
    Stage = c(0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,2,2,2,2,3,3,4),
    Horse = as.character(c(1:8, 1:8, 5:8, 7,8, 7)+4),
    Trainer = rep(2, 23)
)

x11()

plot1 = ggplot(data = trainer1, aes(x = Stage, y = Performance, group = Horse, color = Horse)) +
    geom_line(size = 1.5)
plot2 = ggplot(data = trainer2, aes(x = Stage, y = Performance, group = Horse, color = Horse)) +
    geom_line(size = 1.5)

filename = paste0("horse_training1.png")
png(filename, width = 700L, height = 250L)
grid.arrange(plot1, plot2, ncol = 2)
dev.off()
