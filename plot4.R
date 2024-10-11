setwd("C:/Users/lightni/Desktop")

#calculate memory and load data
#memory estimate: 2m(rows)*9(cols)*8 bytes=2m*9*8/(1024)^2MB
memory<-2075259*9*8/(1024*1024)
print(memory) #around 142MB

# Install readr the first time running the code
# install.packages("readr")

# Load the readr package
library(readr)

# Create a connection to the file
con <- file("household_power_consumption.txt", "r")

# Read the header (first line), note readlines cannot read header, so read it separately and append it later on
header <- readLines(con, n = 1)

#read other parts
data_lines <- readLines(con)

# Close the connection
close(con)

# Filter for the specific dates
filtered_lines <- grep("^[1|2]/2/2007", data_lines, value = TRUE)

#combine header and data
combined_lines <- c(header, filtered_lines)

# Convert filtered data to a data frame
data <- read.csv(text = paste(combined_lines, collapse = "\n"), sep = ";", header = TRUE, na.strings = "?")

#converr time and date from string to time/date format
data$Time<-strptime(paste(data$Date, data$Time), format = "%d/%m/%Y %H:%M:%S") # POSIXLT cannot be coerced into integer, convert into POSIXCT if use axis()
data$Date<-as.Date(data$Date, format = "%d/%m/%Y")
####################
####################
####################

#plot 4
#2 row 2 col
par(mfrow=c(2,2))

# plot 4.1
with(data,plot(as.POSIXct(Time),Global_active_power, type = "l", ylab = "Global Active Power", xlab= "", xaxt = "n"))
# Define the unique weekdays (Thu, Fri, Sat)
weekdays_labels <- c("Thu", "Fri", "Sat")
# Convert to POSIXct to be used in 'at' argument for axis (Thu, Fri, Sat)
x_labels <- as.POSIXct(c("2007-02-01", "2007-02-02", "2007-02-03"))
# Add custom x-axis labels (Thu, Fri, Sat)
axis(1, at = x_labels, labels = weekdays_labels, las = 1)

# plot 4.2
with(data,plot(as.POSIXct(Time),Voltage, type = "l",  xlab= "datetime", xaxt = "n"))
# Add custom x-axis labels (Thu, Fri, Sat)
axis(1, at = x_labels, labels = weekdays_labels, las = 1)

# plot 4.3
with(data,plot(as.POSIXct(Time),Sub_metering_1, type = "l", ylab = "Energy Sub Metering", xlab= "", xaxt = "n"))
with(data,points(Time,Sub_metering_2, type = "l",col='red'))
with(data,points(Time,Sub_metering_3, type = "l",col='blue'))
# Add custom x-axis labels (Thu, Fri, Sat)
axis(1, at = x_labels, labels = weekdays_labels, las = 1)
# Add legend
# Get the current plot's x and y limits to help position the legend, 
# only use "topright" will remove _1/2/3
xlim <- par("usr")[1:2]  # x-axis limits
ylim <- par("usr")[3:4]  # y-axis limits

legend(x = 0.5*xlim[2] + 0.5*xlim[1],  #move legend position horizentally
       y = 0.95*ylim[2] +0.05* ylim[1],       # move legend position vertically
       legend=c("Sub_Metering_1","Sub_Metering_2","Sub_Metering_3"),lty = 1,,col=c("black","red","blue"),
       bty = "n", #remove box
       cex = 0.8) #smaller text

# plot 4.4
with(data,plot(as.POSIXct(Time),Global_reactive_power, type = "l",  xlab= "datetime", xaxt = "n",yaxt="n"))
# Add custom x-axis labels (Thu, Fri, Sat)
axis(1, at = x_labels, labels = weekdays_labels, las = 1)
# Add custom y-axis with finer labels (more detailed tick marks)
y_ticks <- seq(min(data$Global_reactive_power, na.rm = TRUE), max(data$Global_reactive_power, na.rm = TRUE), by = 0.1)  # Adjust the 'by' argument for finer control
axis(2, at = y_ticks, las = 1)  # Add custom y-axis ticks, 'las = 1' makes the labels horizontal


dev.copy(png,file="plot4.png", width = 480, height = 480)
dev.off()


