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


#plot 2
plot(as.POSIXct(data$Time), data$Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)", xlab= "", xaxt = "n") #xaxt = "n" suppresses the default x-axis so that we can manually add our own labels.

# Define the unique weekdays (Thu, Fri, Sat)
weekdays_labels <- c("Thu", "Fri", "Sat")

# Convert to POSIXct to be used in 'at' argument for axis (Thu, Fri, Sat)
x_labels <- as.POSIXct(c("2007-02-01", "2007-02-02", "2007-02-03"))

# Add custom x-axis labels (Thu, Fri, Sat)
axis(1, at = x_labels, labels = weekdays_labels, las = 1)

dev.copy(png,file="plot2.png", width = 480, height = 480)
dev.off()
