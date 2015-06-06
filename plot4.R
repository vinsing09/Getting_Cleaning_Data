plot4 <- function()
{
        #read and format data for plotting
        EDAPROJ1 <- read.table("household_power_consumption.txt", sep = ";", header = TRUE, colClasses = c(rep("character", 2), rep("numeric", 7)), na.strings = "?")
        EDAPROJ1 <- subset(EDAPROJ1, Date == "1/2/2007" | Date == "2/2/2007")
        EDAPROJ1$DateTimePOSIXct <- paste(EDAPROJ1$Date, EDAPROJ1$Time, sep = " ")
        EDAPROJ1$DateTimePOSIXct <- as.POSIXct(EDAPROJ1$DateTime, format="%d/%m/%Y %H:%M:%S")

        #create and open a png device for writing
        png(file = "plot4.png")
        
        #Write plots
        par(mfrow = c(2,2))
        plot(EDAPROJ1$DateTimePOSIXct,EDAPROJ1$Global_active_power, type = "l", ylab = "Global Active Power", xlab = "")
        plot(EDAPROJ1$DateTimePOSIXct,EDAPROJ1$Voltage, type = "l", ylab = "Voltage", xlab = "datetime")
        plot(EDAPROJ1$DateTimePOSIXct, EDAPROJ1$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
        points(EDAPROJ1$DateTimePOSIXct, EDAPROJ1$Sub_metering_2, type = "l", col = "red")
        points(EDAPROJ1$DateTimePOSIXct, EDAPROJ1$Sub_metering_3, type = "l", col = "blue")
        legend("topright", bty = "n", lty = c(1,1,1), col = c("black", "red", "blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
        plot(EDAPROJ1$DateTimePOSIXct,EDAPROJ1$Global_reactive_power, type = "l", ylab = "Global_reactive_power", xlab = "datetime")
        
        
        #close png device
        dev.off()
        
}