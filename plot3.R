# Load necessary packages into R session
library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)

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
        
pwr_consumption2 <- pwr_consumption %>%
        # Select only the Sub_metering and datetime columns
        select(Sub_metering_1:datetime) %>%
        # Gather Sub-Metering columns
        gather(Sub_metering, value, -datetime)

# Open graphics device
png(filename = "plot3.png", width = 480, height = 480)

# Construct the third plot
ggplot(pwr_consumption2,
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

# Close graphics device
dev.off()