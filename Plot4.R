library(data.table)
library(dplyr)
library(lubridate)

#sets the location of the zip file to a location in your current working directory
zipLoc<-'./exdata_data_household_power_consumption.zip'

#unzips the file into a folder called exdata_data_household_power_consumption
unzip(zipLoc)

raw<-tbl_df(read.table('household_power_consumption.txt', header=FALSE, sep= ';'
                       , na.strings = c('?',''), skip=66637, nrows=2880))

#get and apply column headers from first row of data
names<-read.table('household_power_consumption.txt', header=TRUE, sep= ';'
                  , na.strings = c('?',''), nrows=1)

names(raw)<-names(names) 

#Convert the date into a date class object so we can get the Day name
raw$Date=as.Date(raw$Date, '%d/%m/%Y')

raw$DateTime<-paste(raw$Date,raw$Time)
raw$DateTime<-strptime(raw$DateTime,'%Y-%m-%d %H:%M:%S')


#draw the fourth graph
png(filename='plot4.png', width=480, height=480)
par(mfrow=c(2,2), bg='transparent')
#top left
with(raw, plot(raw$DateTime,raw$Global_active_power, 
               ylab='Global Active Power (killowatts)', xlab='',type='l'))
axis.POSIXct(1,x=raw$DateTime)
#top right
plot(raw$DateTime,raw$Voltage, 
     ylab='Voltage', xlab='datetime',type='l')
#bottom left
plot(raw$DateTime,raw$Sub_metering_1, 
     ylab='Energy Sub Metering', xlab='',type='n')
lines(raw$DateTime,raw$Sub_metering_1, type='S')
lines(raw$DateTime,raw$Sub_metering_2, type='S', col='red')
lines(raw$DateTime,raw$Sub_metering_3, type='S', col='blue')
legend('topright', legend = c('Sub_metering_1','Sub_metering_2','Sub_metering_3'),
       col=c('black','red','blue'), lty=c(1,1))
#bottom right
plot(raw$DateTime,raw$Global_reactive_power, 
     ylab='Global_reactive_power', xlab='datetime',type='l')
dev.off()