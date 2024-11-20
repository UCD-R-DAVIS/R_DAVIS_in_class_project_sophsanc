library(tidyverse)
library(lubridate)
library(ggplot2)
library(RColorBrewer)

mloa <- read_csv("https://raw.githubusercontent.com/gge-ucd/R-DAVIS/master/data/mauna_loa_met_2001_minute.csv")
# From README:
    ## Time = UTC
    ## [RELATIVE HUMIDITY] Units are in percent. Missing values are denoted by -99
    ## [TEMPERATURE at 2 Meters] Units are degrees Celsius. Missing values are denoted by -999.9
    ## [WIND SPEED] Units are meters/second. Missing values are denoted by -999.9



# 1. Remove observations with missing values in rel_humid, temp_C_2m, and windSpeed_m_s. 
# 2. Generate a column called “datetime” using the year, month, day, hour24, and min columns.
# 3. Next, create a column called “datetimeLocal” that converts the datetime column to Pacific/Honolulu time 
# 4. Then, use dplyr to calculate the mean hourly temperature each month using the temp_C_2m column and the datetimeLocal columns. (HINT: Look at the lubridate functions called month() and hour()).
mloa_filtered <- mloa %>% 
  filter(rel_humid != -99, #1
         temp_C_2m != -999.9,
         windSpeed_m_s != -99.9) %>% #README says NAs are -999.9, but in df it looks like they're -99.9
  mutate(datetime = ymd_hm(paste0(year,"-", #2
                                  month, "-", 
                                  day,", ", 
                                  hour24, ":", 
                                  min), 
                           tz = "UTC")) %>%
  mutate(datetimeLocal = with_tz(datetime, tz = "Pacific/Honolulu")) %>% #3
  mutate(local_hour = hour(datetimeLocal), #4
         local_month = month(datetimeLocal))

mloa_summarized <- mloa_filtered %>% #4 cont.
  group_by(local_month, local_hour) %>% 
  summarise(mean_temp2m = mean(temp_C_2m))
  
# 5. Finally, make a ggplot scatterplot of the mean monthly temperature, with points colored by local hour.
mloa_scatterplot <- mloa_summarized %>% 
  ggplot(mapping = aes(x = local_month, y = mean_temp2m, color = local_hour)) +
  geom_point() +
  scale_color_viridis_c("local_hour") +
  xlab("Month") +
  ylab("Mean Temperature (C), 2m")

