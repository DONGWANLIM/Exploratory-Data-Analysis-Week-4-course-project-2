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

#Dataset manipulation
NEI_q5 <- base::subset(x = NEI, NEI$fips=="24510" & NEI$type=="ON-ROAD")

plot_5_data <- NEI_q5 %>%
  dplyr::group_by(year) %>%
  dplyr::summarise(Total = base::sum(Emissions))

#Make a Plot5
grDevices::png(filename = "Plot5.png", height = 480, width = 800)
  ggplot2::ggplot(data = plot_5_data,
                  ggplot2::aes(x = year,
                               y = Total)) +
  ggplot2::geom_bar(position = "stack",
                    stat = "identity") +
  ggplot2::geom_text(data = plot_5_data,
                     ggplot2::aes(x = year,
                                  label = base::format(x = Total,
                                                       nsmall = 1,digits = 1),
                                  y = Total,
                                  fill = NULL),
                     nudge_y = 10) +
  ggplot2::scale_x_discrete(limits = c(1999, 2002, 2005, 2008)) +
  ggplot2::labs(title = base::expression('Vehicle Emissions PM'[2.5] ~ ' in Baltimore')) +
  ggplot2::xlab("Year") +
  ggplot2::ylab(base::expression('Total PM'[2.5] ~ 'Emissions (tons)')) +
  ggplot2::theme(legend.position = "bottom",
                 legend.title.align = 0.5,
                 plot.title = ggplot2::element_text(hjust = 0.5)) +
  ggplot2::guides(fill = ggplot2::guide_legend(title = "")) -> p5
  base::print(p5)
grDevices::dev.off()
