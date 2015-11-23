## Plot4.R

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

## Question 4
## Across the United States, how have emissions from coal combustion-related 
## sources changed from 1999–2008?


## Subset the data according to the parameters of the question and take the sums of Emissions
totalEmission <- neisccDF %>%
                group_by(year, SCC.Level.Three) %>% 
                filter(grepl("Combustion", SCC.Level.One), grepl("Coal", SCC.Level.Three)) %>%
                summarise_each(funs(sum), Emissions)

## create a plot that has four panels arranged 2x2 to show the emissions from different
## motor coal combution sources
plot <- ggplot(totalEmission, aes(year, Emissions/1000)) + 
  geom_line(color = "blue") +
  facet_wrap( ~ SCC.Level.Three, nrow = 2, ncol = 2, scales = "free")  + xlab("Year") +
  ylab("Total Emissions, ThousandsTons") +
  ggtitle("Total US PM2.5 Emissions from Coal Combustion Sources")

#Write the plot to plot4.png
png(file = "plot4.png", width = 480, height = 480)
print(plot)
dev.off()