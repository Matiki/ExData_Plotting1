# Load necessary packages into R session
library(readr)
library(dplyr)
library(ggplot2)


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
        filter(Date == "2007-02-01" | Date == "2007-02-02") %>%
        # Combine Date and Time into new column: datetime
        mutate(datetime = as.POSIXct(paste(Date, Time)))


# Open graphics device
png(filename = "plot2.png", width = 480, height = 480)

# Construct the second plot
ggplot(pwr_consumption,
       aes(x = datetime, y = Global_active_power)) +
        geom_line() + 
        scale_x_datetime(name = NULL,
                         date_breaks = "1 day",
                         date_labels = "%a") +
        scale_y_continuous("Global Active Power (kilowatts)") +
        theme_classic()

# Close graphics device
dev.off()