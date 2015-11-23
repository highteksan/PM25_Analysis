## Plot1.R

library(dplyr)

if(!file.exists("PM25_data.zip")) {
  URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(URL, "PM25_data.zip")
  unzip("PM25_data.zip")
}
## Read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Question 1
## Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
## Using the base plotting system, make a plot showing the total PM2.5 emission 
## from all sources for each of the years 1999, 2002, 2005, and 2008.

## Subset the data according to the parameters of the question and take the sum of Emissions
totalEmission <- NEI %>%
                  group_by(year) %>%
                  summarise_each(funs(sum), Emissions)


## set global base plotting parameters
par(cex = "0.75") ## set the font size to 75% of default
par(las = 1) ## make axis lables always horizontal
                  
## create the X-Y plot of Date-Time versus Global Active Power 
## and write it to plot1.png
png(file = "plot1.png", width = 480, height = 480)
with(totalEmission, plot(year, Emissions/1000000, xaxt = "n",
                         type ="l", col = "blue", lwd = "3", 
                         xlab ="Year", ylab = "Total Emissions, Millions Tons"))
## add title
title("PM 2.5 Emissions from All Sources: United States")
axis(1, at = c("1999", "2002", "2005", "2008"))
## create a legend, but this time with no boarder line
legend("topright", bty = "n", lty = "solid", lwd = 3, col = "blue", 
                  legend = c("Total Emissions United States"))
                  
dev.off()