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
#Plot2
png(file="plot2.png",width = 480, height = 480)
t <- as.numeric(difftime(data_fin$DateTime,begin_mes,units="days"))

with(data_fin,plot(t,Global_active_power,type="l",
                   axes=FALSE,xlab="",ylab = "Global Active Power (kilowatts)" ))
axis(side=1, at=seq(0,2,1), labels = c("Thu","Fri","Sat"))
axis(side=2, at=seq(0,6,2))
box()
dev.off()
