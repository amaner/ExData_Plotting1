## plot1.R
## this program makes a histogram for Global Active Power (in kilowatts)
## inputs: household_power_consumption.txt
## outputs: a properly-labeled 480x480 histogram in PNG format

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

## make the histogram on the screen device
hist(powdat$Global_active_power,xlab="Global Active Power (kilowatts)",ylab="Frequency",main="Global Active Power",col="red")
## save it to a png (default is 480x480)
dev.copy(png, 'plot1.png')
dev.off()
