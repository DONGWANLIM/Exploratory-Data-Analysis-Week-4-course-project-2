#Unzip and load files
library(magrittr)
library(tidyverse)
library(ggplot2)

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

#Create a subsetting for Baltimore City
NEI_q3 <- base::subset(x = NEI, NEI$fips == "24510")

#Summarize the dataset to calculate the total summation by year and type
plot_3_data <- NEI_q3 %>%
  dplyr::group_by(type, year) %>%
  dplyr::summarise(total = base::sum(Emissions))

#Make a Plot3
grDevices::png(filename = "plot3.png", height = 480, width = 800)
  ggplot2::ggplot(data = plot_3_data,
                  ggplot2::aes(x = year,
                               y = total,
                               label = base::format(x = total,
                                                    nsmall = 1,
                                                    digits = 1))) +
  ggplot2::geom_line(ggplot2::aes(color = type), lwd = 1) +
  ggplot2::geom_text(hjust = 0.5, vjust = 0.5) +
  ggplot2::scale_x_discrete(limits = c(1999, 2002, 2005, 2008)) +
  ggplot2::labs(title = base::expression('Emissions of PM'[2.5] ~ ' in Baltimore')) +
  ggplot2::xlab("Year") +
  ggplot2::ylab(base::expression("Total PM"[2.5] ~ "emission (tons)")) +
  ggplot2::theme(legend.position = "right",
                 legend.title.align = 0.5,
                 plot.title = ggplot2::element_text(hjust = 0.5))

grDevices::dev.off()
