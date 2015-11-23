## Plot6.R

library(dplyr)
library(ggplot2)

if(!file.exists("PM25_data.zip")) {
  URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(URL, "PM25_data.zip")
  unzip("PM25_data.zip")
}

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
neisccDF <- left_join(NEI, SCC)
## Question 6
## Compare emissions from motor vehicle sources in Baltimore City with emissions 
## from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
## Which city has seen greater changes over time in motor vehicle emissions?

## Subset the data according to the parameters of the question and take the sums of Emissions
totalEmission <- neisccDF %>%
            group_by(year, fips) %>%
            filter(fips == "06037"| fips == "24510") %>%
            filter(grepl("On-Road", EI.Sector)) %>%
            summarise_each(funs(sum), Emissions)

## change the fips to Los Angeles and Baltimore City
totalEmission$fips[totalEmission$fips == "06037"] <- "Los Angeles"
totalEmission$fips[totalEmission$fips == "24510"] <- "Baltimore City"

## create a 2 panel plot to compare the total motor vehicle emissions for 
## Los Angeles and Baltimor city side by side so the rate of changes can be seen 
plot <- ggplot(totalEmission, aes(year, Emissions/1000)) + 
        geom_line(color = "blue") +
        facet_wrap( ~fips, nrow = 1, ncol = 2, scales = "free") +
        xlab("Year") +
        ylab("Total Emissions, ThousandsTons") +
        ggtitle("Total PM2.5 Emissions from Motor Vehicles")

## Write plot to plot6.png
png(file = "plot6.png", width = 480, height = 480)
print(plot)
dev.off()

