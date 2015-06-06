plot1 <- function()
{
        #read and format data for plotting
        EDAPROJ1 <- read.table("household_power_consumption.txt", sep = ";", header = TRUE, colClasses = c(rep("character", 2), rep("numeric", 7)), na.strings = "?")
        EDAPROJ1 <- subset(EDAPROJ1, Date == "1/2/2007" | Date == "2/2/2007")
        EDAPROJ1$DateTimePOSIXct <- paste(EDAPROJ1$Date, EDAPROJ1$Time, sep = " ")
        EDAPROJ1$DateTimePOSIXct <- as.POSIXct(EDAPROJ1$DateTime, format="%d/%m/%Y %H:%M:%S")
        
	#open png device for writing
        png(file = "plot1.png")
	
	#plot data
        par(mfrow = c(1,1))
        hist(EDAPROJ1$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
	
	#close png device
        dev.off()
        
}