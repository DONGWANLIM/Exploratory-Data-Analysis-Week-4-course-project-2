#Unzip and load files
library(magrittr)
library(tidyverse)

#Create a folder
if(!base::file.exists("data")) {
  base::dir.create("data")
}

#Download data
if(!base::file.exists("./data/FNEI_data.zip")){
  utils::download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                       destfile = "./data/FNEI_data.zip")
}

#Unzip data
if(!base::file.exists("./data/unzipped/Source_Classification_Code.rds") | !base::file.exists("./data/unzipped/summarySCC_PM25.rds")){
  utils::unzip(zipfile = "./data/FNEI_data.zip",
               exdir = "./data/unzipped/",
               list = FALSE,
               overwrite = TRUE)
}

#Loading RDS files
NEI <- base::readRDS("./data/unzipped/summarySCC_PM25.rds")
SCC <- base::readRDS("./data/unzipped/Source_Classification_Code.rds")

#Dataset manipulation
plot_1_data <- NEI %>%
  dplyr::group_by(year) %>%
  dplyr::summarise(total = base::sum(Emissions))

#Make a Plot1
base::with(data = plot_1_data, {
  grDevices::png(filename = "plot1.png", height = 480, width = 800)
    par(oma = c(1,1,1,1))
    p <- graphics::barplot(height = total/1000000, name = year,
                           main = base::expression('Total PM'[2.5] ~ ' in the United States'),
                           ylab = base::expression('PM'[2.5] ~ 'Emissions (10' ^6 ~ 'tons)'),
                           xlab = "Year");
    text(x = p,
         y = total/1000000 - 0.5,
         label = format(total/1000000,
                        nsmall = 1,
                        digits = 1))
    grDevices::dev.off()
})
