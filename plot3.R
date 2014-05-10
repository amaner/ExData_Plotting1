## plot3.R
## makes a line chart of the three sub_metering variables versus time of day
## sub_metering_1 coded black, sub_metering_2 coded red, and sub_metering_3 coded blue
## chart includes a legend at top right
## inputs: household_power_consumption.txt
## outputs: a properly-labeled 480x480 line chart in PNG format

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

## set up the plot window
## use sub_metering_1 for y scale, since it spikes the highest
plot(powdat$Date_Time, powdat$Sub_metering_1, type="n", ylab="Engery sub metering", xlab="")
## add black sub_metering_1 line
lines(powdat$Date_Time, powdat$Sub_metering_1, col="black")
## add red sub_metering_2 line
lines(powdat$Date_Time, powdat$Sub_metering_2, col="red")
## add blue sub_metering_3 line
lines(powdat$Date_Time, powdat$Sub_metering_3, col="blue")
## set the legend
## first argument sets it at top right
## second argument sets the labels
## third argument sets the legend symbols to lines
## fourth argument sets a nice width for these lines
## fifth argument sets the colors for the lines
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty=c(1,1,1), lwd=c(2.5,2.5,2.5), col=c("black","red","blue"))

## copy the image to a png file
dev.copy(png, 'plot3.png')
dev.off()
