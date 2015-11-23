## Plot5.R

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

## Question 5
## How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

## Subset the data according to the parameters of the question and take the sums of Emissions
totalEmission <- neisccDF %>%
                group_by(year, fips, EI.Sector) %>%
                filter(fips == "24510") %>%
                filter(grepl("On-Road", EI.Sector)) %>%
                summarise_each(funs(sum), Emissions)
## shorten the names of the different motor vehicle sources
totalEmission$EI.Sector <- gsub("Mobile - On-Road", "", totalEmission$EI.Sector)
totalEmission$EI.Sector <- gsub("Vehicles", "", totalEmission$EI.Sector)
## create a four panel plot to show the different motor vehicle sources
plot <- ggplot(totalEmission, aes(year, Emissions/1000)) + 
        geom_line(color = "blue") +
        facet_wrap( ~ EI.Sector, nrow = 2, ncol = 2, scales = "free")  + xlab("Year") +
        ylab("Total Emissions, ThousandsTons") +
        ggtitle("Total Baltimore City PM2.5 Emissions from Motor Vehicles")

## write plot to plot5.png
png(file = "plot5.png", width = 480, height = 480)
print(plot)
dev.off()