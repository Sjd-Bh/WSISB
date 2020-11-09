rm(list=ls())
load("../../covid-19/outputs/perf_risk.RData" )

library(fmsb)
#########################################################################################
dat = as.data.frame(perfRisks[, -1])

res =  aggregate(.~riskNr, dat, mean)

rownames(res) = paste0(res$riskNr, "RG")
data = t(res[, -1])
# To use the fmsb package, I have to add 2 lines to the dataframe: the max and min of each variable to show on the plot!
maxTestNum = 6200
minTestNum = 5000
data <-  as.data.frame(rbind(rep(maxTestNum,ncol(data)) , rep(minTestNum,ncol(data)) , data))

# # Color vector
# colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
# colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )

colors_border = c("red", "green", "blue", "orange")
rgb.val = col2rgb(colors_border)

percent = 90
## Make new color using input color as base and alpha set by transparency
colors_in <- rgb(rgb.val[1, ], rgb.val[2, ], rgb.val[3, ],
             max = 255,
             alpha = (100 - percent) * 255 / 100)




# save in files 
fig_folder = "../../figures/"
dir.create(fig_folder, showWarnings = FALSE, recursive = TRUE)


pdf(paste0(fig_folder, "perf_risk_radar.pdf"))
labs = seq(minTestNum, maxTestNum, length.out=5)/100
radarchart( data  , axistype=1 ,
            #custom polygon
            pcol=colors_border, pfcol=colors_in, plwd=1 , plty=1,
            #custom the grid
            cglcol="grey", cglty=1, axislabcol="grey", caxislabels=labs, cglwd=0.8,
            #custom labels
            vlcex=0.8 
)

legend(x=1.7, y=1, legend = rownames(data[-c(1,2),]), bty = "n", pch=20 , col=colors_border , text.col = "grey", cex=1.2, pt.cex=1)
dev.off()



png(paste0(fig_folder, "perf_risk_radar.png"))
labs = seq(minTestNum, maxTestNum, length.out=5)/100
radarchart( data  , axistype=1 ,
            #custom polygon
            pcol=colors_border, pfcol=colors_in, plwd=1 , plty=1,
            #custom the grid
            cglcol="grey", cglty=1, axislabcol="grey", caxislabels=labs, cglwd=0.8,
            #custom labels
            vlcex=0.8 
)

legend(x=1.7, y=1, legend = rownames(data[-c(1,2),]), bty = "n", pch=20 , col=colors_border , text.col = "grey", cex=1.2, pt.cex=1)
dev.off()





pdf(paste0(fig_folder, "perf_risk_radar_bigger_label.pdf"))
labs = seq(minTestNum, maxTestNum, length.out=5)/100
radarchart( data  , axistype=1 ,
            #custom polygon
            pcol=colors_border, pfcol=colors_in, plwd=1 , plty=1,
            #custom the grid
            cglcol="grey", cglty=1, axislabcol="grey", caxislabels=labs, cglwd=0.8,
            #custom labels
            vlcex=1 
)

legend(x=1.7, y=1, legend = rownames(data[-c(1,2),]), bty = "n", pch=20 , col=colors_border , text.col = "grey", cex=1.2, pt.cex=1)
dev.off()


pdf(paste0(fig_folder, "perf_risk_radar_no_label.pdf"))
labs = seq(minTestNum, maxTestNum, length.out=5)/100
radarchart( data  , axistype=1 ,
            #custom polygon
            pcol=colors_border, pfcol=colors_in, plwd=1 , plty=1,
            #custom the grid
            cglcol="grey", cglty=1, axislabcol="grey", caxislabels=labs, cglwd=0.8,
            #custom labels
            vlcex=1, vlabels=rep("", 7)
)

legend(x=1.7, y=1, legend = rownames(data[-c(1,2),]), bty = "n", pch=20 , col=colors_border , text.col = "grey", cex=1.2, pt.cex=1)
dev.off()
