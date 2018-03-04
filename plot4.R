# Load necessary packages into R session 
library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)
library(gridExtra)

# Read data into R, initializing column types
pwr_consumption <- read_delim("household_power_consumption.txt",
                              delim = ";",
                              locale = locale(decimal_mark = "."), 
                              na = "?",
                              col_types = list(col_date(format = "%d/%m/%Y"),
                                               col_time(format = "%H:%M:%S"),
                                               "n", "n","n","n","n","n","n"))

# Filter rows to appropriate dates, create new column: datetime
pwr_consumption <- pwr_consumption %>%
        filter(Date == "2007-02-01" | Date == "2007-02-02") %>%
        mutate(datetime = as.POSIXct(paste(Date, Time)))

pwr_consumption2 <- pwr_consumption %>%
        # Select only the Sub_metering and datetime columns
        select(Sub_metering_1:datetime) %>%
        # Gather Sub-Metering columns
        gather(Sub_metering, value, -datetime)

# Construct the final four plots
p1 <- ggplot(pwr_consumption,
             aes(x = datetime, y = Global_active_power)) +
        geom_line() + 
        scale_x_datetime(name = NULL,
                         date_breaks = "1 day",
                         date_labels = "%a") +
        scale_y_continuous("Global Active Power (kilowatts)") +
        theme_classic()

p2 <- ggplot(pwr_consumption,
             aes(x = datetime, y = Voltage)) +
        geom_line() +
        scale_x_datetime(name = NULL,
                         date_breaks = "1 day",
                         date_labels = "%a") +
        scale_y_continuous("Voltage",
                           breaks = c(234, 238, 242, 246)) +
        theme_classic()

p3 <- ggplot(pwr_consumption2,
             aes(x = datetime, y = value)) +
        geom_line(aes(col = Sub_metering)) +
        scale_x_datetime(name = NULL,
                         date_breaks = "1 day",
                         date_labels = "%a") +
        scale_y_continuous("Energy Sub-Metering") +
        scale_colour_manual(values = c("black", "red", "blue")) +
        theme_classic() +
        theme(legend.title = element_blank(),
              legend.justification = c(1, 1),
              legend.position = c(1, 1),
              legend.background = element_rect(color = 1)) 

p4 <-  ggplot(pwr_consumption,
              aes(x = datetime, y = Global_reactive_power)) +
        geom_line() + 
        scale_x_datetime(name = NULL, 
                         date_breaks = "1 day",
                         date_labels = "%a") +
        scale_y_continuous("Global Reactive Power") +
        theme_classic()

# Open graphics device, call plotting function, close graphics device
png(filename = "plot4.png", width = 480, height = 480)

grid.arrange(p1, p2, p3, p4, nrow = 2)

dev.off()