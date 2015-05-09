########################################################################
# Note the script requires dplyr and lubridate packages to be installed
# To install, run the following lines:
# install.packages("dplyr")
# install.packages("lubridate")
# The script also expects a data file named household_power_consumption.txt
# to exist in the same directory as the script.
# If the file is not present you will be prompted to download
# the file so the script can run.
########################################################################

library(dplyr)
library(lubridate)

file_name = "household_power_consumption.txt"

download <- function () {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "power_consumption.zip", method="curl")
  utils::unzip("power_consumption.zip")
}

makeplot <- function(df) {
  par(mfrow = c(1,1))
  plot(df$Sub_metering_1 ~ df$datetime, type="l", xlab="", ylab="Energy sub metering")
  lines(df$Sub_metering_2 ~ df$datetime,col="Red")
  lines(df$Sub_metering_3 ~ df$datetime, col="Blue")
  legend("topright", col=c("Black", "Red", "Blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd=1)
}

run <- function() {
  
  print ("Making plot 3...")
  # load the data
  df <- read.table(file_name, sep=";", header=TRUE, na.strings=c("?"), skip=66635, nrows=2880)
  colnames(df) <- c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
  df <- mutate(df, datetime = dmy_hms(paste(Date, Time)))
  
  # print plot to screen
  makeplot(df)
  
  #print plot to png file
  print("Writing the plot to plot3.png...")
  png("plot3.png", width=480, height=480)
  makeplot(df)
  dev.off()
}

#ensure file is available
if (file.exists(file_name)) {
  run()
} else {
  yn <- readline(prompt="Data file does not exist. Would you like to download it? Y/N ")
  if (tolower(yn) == "y") {
    download()
    run()
  } else {
    print("Unable to run the program")
  }
}





