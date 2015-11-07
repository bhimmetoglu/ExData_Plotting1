# Store data classes for fast read
dat_class <- c(rep("character",2),rep("numeric",7))

# Data starts at 16/12/2006 17:24:00, Notice that the format is
# Day/Month/Year and 24h time
zero <- strptime("2006-12-16 17:24:00", "%Y-%m-%d %H:%M:%S")

# Measurement starting and ending instances of interest
begin_mes <- strptime("2007-02-01 00:00:00", "%Y-%m-%d %H:%M:%S")
end_mes <- strptime("2007-02-03 00:00:00", "%Y-%m-%d %H:%M:%S")

# Determine the number of lines to be skipped
skp <- as.numeric(difftime(begin_mes,zero,units = "min"))

# Determine the number of rows to be read
nrw <- as.numeric(difftime(end_mes,begin_mes,units = "min"))
nrw <- nrw + 1

# Read headers
header <- read.table("household_power_consumption.txt",
                     nrows = 1,stringsAsFactors = FALSE,sep=";")

# Read only the data between begin_mes and end_mes
data_init <- read.table("household_power_consumption.txt",skip=skp,nrows = nrw,
                        sep = ";", colClasses = dat_class, na.strings = "?", 
                        header=TRUE)

# Insert headers back 
colnames(data_init) <- unlist(header)

str_datetime <- paste(data_init$Date,data_init$Time)
col_datetime <- strptime(str_datetime,"%d/%m/%Y %H:%M:%S")
data_fin <- data.frame(DateTime=col_datetime,data_init[,3:9])

# Plotting
#Plot4
png(file="plot4.png",width = 480, height = 480)
par(mfrow=c(2,2))
#(1,1)
with(data_fin,plot(t,Global_active_power,type="l",
                   axes=FALSE,xlab="",ylab = "Global Active Power (kilowatts)" ))
axis(side=1, at=seq(0,2,1), labels = c("Thu","Fri","Sat"))
axis(side=2, at=seq(0,6,2))
box()
# (1,2)
with(data_fin,plot(t,Voltage,type="l",
                   axes = FALSE,xlab = "datetime", ylab = "Voltage"))
axis(side=1, at=seq(0,2,1), labels = c("Thu","Fri","Sat"))
axis(side=2, at=seq(234,246,4))
box()
#(2,1)
with(data_fin,plot(t, Sub_metering_1, type="l",col="black",axes = FALSE,
                   xlab="",ylab="Energy sub metering"))
with(data_fin,lines(t, Sub_metering_2, type="l",col="red"))
with(data_fin,lines(t, Sub_metering_3, type="l",col="blue"))
legend(x="topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty=c(1,1,1),col=c("black","red","blue"))
axis(side=1, at=seq(0,2,1), labels = c("Thu","Fri","Sat"))
axis(side=2, at=seq(0,30,10))
box()
# (2,2)
with(data_fin,plot(t,Global_reactive_power,type="l",axes = FALSE,
                   xlab = "datetime", ylab = "Global_reactive_power"))
axis(side=1, at=seq(0,2,1), labels = c("Thu","Fri","Sat"))
axis(side=2, at=seq(0.0,0.5,0.1))
box()

dev.off()
