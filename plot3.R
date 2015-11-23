## Plot3.R

library(dplyr)
library(ggplot2)

if(!file.exists("PM25_data.zip")) {
  URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(URL, "PM25_data.zip")
  unzip("PM25_data.zip")
}
## read the data and join the two data sets into one
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
neisccDF <- left_join(NEI, SCC) 

## Question 3
## Of the four types of sources indicated by the type (point, nonpoint, 
## onroad, nonroad) variable, which of these four sources have seen 
## decreases in emissions from 1999–2008 for Baltimore City? Which have 
## seen increases in emissions from 1999–2008? Use the ggplot2 plotting 
## system to make a plot answer this question.

## Subset the data according to the parameters of the question and take the sums of Emissions
totalEmission <- neisccDF %>%
                  group_by(type, year) %>%
                  summarise_each(funs(sum), Emissions)

## Use ggplot to create the plot with free scales on the y-axis so trends can be 
## easily viewed.
plot <- ggplot(totalEmission, aes(year, Emissions/1000000)) + 
        geom_line(color = "blue") +
        facet_wrap( ~ type, nrow = 2, ncol = 2, scales = "free")  + xlab("Year") +
        ylab("Total Emissions, Millions Tons") +
        ggtitle("Total US PM2.5 Emissions from All Source Types")

## write plot to plot3.png
png(file = "plot3.png", width = 480, height = 480)      
print(plot)
dev.off()