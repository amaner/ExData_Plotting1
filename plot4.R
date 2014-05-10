## plot4.R
## makes a 2x2 array of images
## top left is a line chart showing global_active_power vs date_time
## top right is a line chart showing voltage vs date_time
## bottom left is a line chart showing sub_metering_1, sub_metering_2,
## and sub_metering_3 vs date_time.  sm1 is black, sm2 is red, and sm3 is blue
## bottom right is a line chart showing global_reactive_power vs date_time
## inputs: household_power_consumption.txt
## outputs: a 480x480 png file titled plot4.png

## read data file into R
powdat <- read.table("household_power_consumption.txt",header=TRUE,sep=";",colClasses="character",stringsAsFactors=FALSE)

## numeric columns come in as chars, cast as numeric
## this will also replace ? chars with NAs 
suppressWarnings(powdat$Global_active_power   <- as.numeric(powdat$Global_active_power))
suppressWarnings(powdat$Global_reactive_power <- as.numeric(powdat$Global_reactive_power))
suppressWarnings(powdat$Voltage               <- as.numeric(powdat$Voltage))
suppressWarnings(powdat$Global_intensity      <- as.numeric(powdat$Global_intensity))
suppressWarnings(powdat$Sub_metering_1        <- as.numeric(powdat$Sub_metering_1))
suppressWarnings(powdat$Sub_metering_2        <- as.numeric(powdat$Sub_metering_2))
suppressWarnings(powdat$Sub_metering_3        <- as.numeric(powdat$Sub_metering_3))

## remove rows with NAs
powdat <- powdat[complete.cases(powdat),]
## grab only rows for 1/2/2007 and 2/2/2007
powdat <- rbind(subset(powdat,powdat$Date == "1/2/2007"), subset(powdat,powdat$Date == "2/2/2007"))

## pull off date and time columns to convert them
tmp <- as.data.frame(paste(powdat$Date,powdat$Time))
## name the column
colnames(tmp) <- "Date_Time"
## convert to actual date times
tmp <- strptime(tmp$Date_Time, format="%d/%m/%Y %H:%M:%S")
## add this as a column to powdat, removing the old date and time columns
## columns 3:9 have the data
powdat <- cbind(tmp, powdat[,3:9])
## be sure the names are right
colnames(powdat) <- c("Date_Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")

## need 2 rows x 2 columns
par(mfrow=c(2,2))
## set up top left - global_active_power vs date_time
plot(powdat$Date_Time, powdat$Global_active_power, type="n", ylab="Global Active Power (kilowatts)", xlab="")
## add the line chart
lines(powdat$Date_Time, powdat$Global_active_power)
## set up top right - voltage vs date_time
plot(powdat$Date_Time, powdat$Voltage, type="n", ylab="Voltage", xlab="datetime")
## add the line chart
lines(powdat$Date_Time, powdat$Voltage)
## set up the bottom left - submetering 1:3 vs date_time
plot(powdat$Date_Time, powdat$Sub_metering_1, type="n", ylab="Energy sub metering", xlab="")
## add the lines
lines(powdat$Date_Time, powdat$Sub_metering_1, col="black")
lines(powdat$Date_Time, powdat$Sub_metering_2, col="red")
lines(powdat$Date_Time, powdat$Sub_metering_3, col="blue")
## add the legend
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty=c(1,1,1), cex=0.5, bg="white", box.col="white", col=c("black","red","blue"))
## set up the bottom right - global_reactive_power vs date_time
plot(powdat$Date_Time, powdat$Global_reactive_power, type="n", xlab="datetime", ylab="Global_reactive_power")
## add the line chart
lines(powdat$Date_Time, powdat$Global_reactive_power)

## copy the image to a png file
dev.copy(png, 'plot4.png')
dev.off()
