# Creating the second plot

#   Load packages
library(readr)
library(dplyr)
library(naniar)


#   Download and unzip the file ----
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
fileName <- "hh_power_comp.zip"
fileFolder <- "data"
dataDest <- "inst/extdata/"

if(!file.exists(paste0("inst/extdata/", fileName))){
  download.file(url = fileUrl,
                destfile = paste0("inst/extdata/", fileName),
                method = "curl")
}

if(!file.exists(paste0("inst/extdata/", fileFolder))){
  unzip(paste0("inst/extdata/", fileName), exdir = dataDest)
}

#   Read the data ----
path <- paste0(getwd(), "/", dataDest)

hhpc_data <- read_delim(
  file.path(path, "household_power_consumption.txt"),
  delim = ";",
  col_names = TRUE,
  col_types = list(
    Date = col_date(format = "%d/%m/%Y"),
    Time = "t",
    Global_active_power = "n",
    Global_reactive_power = "n",
    Voltage = "n",
    Global_intensity = "n",
    Sub_metering_1 = "n",
    Sub_metering_2 = "n",
    Sub_metering_3 = "n"
  )
)

#   Filter the data ----
hhpc_data <- hhpc_data %>% filter(Date == "2007-02-01" | Date == "2007-02-02")
datetime <- paste(hhpc_data$Date, hhpc_data$Time)
hhpc_data <- hhpc_data %>% mutate(
  Datetime = as.POSIXct(datetime, "%d/%m/%Y %H:%M:%S")
  )

#   Plot 2 ----
# Creating the file
png(
  filename = "plot2.png",
  width = 480,
  height = 480,
  units = "px"
)

# Adding the plot into the file
plot(
  x = hhpc_data$Datetime,
  y = hhpc_data$Global_active_power,
  type = "l",
  xaxt = "n",
  xlab = "",
  ylab = "Global Active Power (kilowatts)"
)
# Add x axis measures as abbreviated weekdays
axis.POSIXct(
  1,
  hhpc_data$Datetime,
  at = seq(
    from = as.POSIXct("2007-02-01 00:00:00"),
    to = as.POSIXct("2007-02-03 00:00:00"),
    by = "1 day"
  ),
  format = "%a"
)


# Closing the graphical device
dev.off()
