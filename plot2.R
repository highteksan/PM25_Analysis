## Plot2.R

library(dplyr)

if(!file.exists("PM25_data.zip")) {
  URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(URL, "PM25_data.zip")
  unzip("PM25_data.zip")
}
## Read the Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Question 2
## Have total emissions from PM2.5 decreased in the Baltimore City, 
## Maryland (fips == "24510") from 1999 to 2008? Use the base plotting 
## system to make a plot answering this question.

## Subset the data according to the parameters of the question and take the sums of Emissions
totalEmission <- NEI %>%
          filter(fips == "24510") %>%
          group_by(year) %>%
          summarise_each(funs(sum), Emissions)


## set global base plotting parameters
par(cex = "0.75") ## set the font size to 75% of default
par(las = 1) ## make axis lables always horizontal

## create the X-Y plot of Date-Time versus Global Active Power  
## and write it to the png file.
png(file = "plot2.png", width = 480, height = 480)
with(totalEmission, plot(year, Emissions/1000, xaxt = "n",
                         type ="l", col = "blue", lwd = "3", 
                         xlab ="Year", ylab = "Emissions, Thousand Tons"))
## add title

title("PM 2.5 Emisions from All Sources: Baltimore City MD")
axis(1, at = c("1999", "2002", "2005", "2008"))
## create a legend, but this time with no boarder line
legend("topright", bty = "n", lty = "solid", lwd = 3, col = "blue", 
       legend = c("Total Emissions Baltamore City"))

dev.off()