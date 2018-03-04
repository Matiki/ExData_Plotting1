# Load necessary packages into R session
library(readr)
library(dplyr)

# Read data into R, initializing column types
pwr_consumption <- read_delim("household_power_consumption.txt",
                             delim = ";",
                             locale = locale(decimal_mark = "."), 
                             na = "?",
                             col_types = list(col_date(format = "%d/%m/%Y"),
                                              col_time(format = "%H:%M:%S"),
                                              "n", "n","n","n","n","n","n"))

# Filter rows to appropriate dates
pwr_consumption <- pwr_consumption %>%
        filter(Date == "2007-02-01" | Date == "2007-02-02")

# Open graphics device
png(filename = "plot1.png", width = 480, height = 480)

# Construct the first plot
hist(x = pwr_consumption$Global_active_power, 
     col = "red", 
     xlab = "Global Active Power (kilowatts)", 
     main = "Global Active Power")

# Close graphics device
dev.off()