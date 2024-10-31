# Midterm
# Sanchez, Sophia

#1.  Read in the file tyler_activity_laps_10-24.csv from the class github page. This file is at url https://raw.githubusercontent.com/ucd-cepb/R-DAVIS/refs/heads/main/data/tyler_activity_laps_10-24.csv, so you can code that url value as a string object in R and call read_csv() on that object. The file is a .csv file where each row is a “lap” from an activity Tyler tracked with his watch.

library(tidyverse)
file_location <- 'https://raw.githubusercontent.com/ucd-cepb/R-DAVIS/refs/heads/main/data/tyler_activity_laps_10-24.csv'
data_raw <- read.csv(file_location)


#2. Filter out any non-running activities.

data_filtered <- data_raw %>% 
  filter(sport == 'running') ## filtering only running rows

unique(data_filtered$sport) ## checking only running rows remain


#3. Next, Tyler often has to take walk breaks between laps right now because trying to change how you’ve run for 25 years is hard. You can assume that any lap with a pace above 10 minute-per-mile pace is walking, so remove those laps. You should also remove any abnormally fast laps (< 5 minute-per-mile pace) and abnormally short records where the total elapsed time is one minute or less.

data_filtered <- data_filtered %>% 
  filter(minutes_per_mile < 10, ## filtering for laps shorter than 10min/mi
         minutes_per_mile > 5, ## filtering for laps longer than 5min/mi
         total_elapsed_time_s > 60) ## filtering for laps longer than 1 min
         
data_filtered %>% arrange(minutes_per_mile) ## checking minimum min/mi
data_filtered %>% arrange(-minutes_per_mile) ## checking maximum min/mi
data_filtered %>% arrange(total_elapsed_time_s) ## checking minimum total time


#4. Create a new categorical variable, pace, that categorizes laps by pace: “fast” (< 6 minutes-per-mile), “medium” (6:00 to 8:00), and “slow” ( > 8:00). Create a second categorical variable, form that distinguishes between laps run in the year 2024 (“new”, as Tyler started his rehab in January 2024) and all prior years (“old”).

data_filtered <- data_filtered %>% 
  mutate(pace = case_when(
    minutes_per_mile < 6 ~ "fast", ## if less than 6s, label fast
    minutes_per_mile < 8 ~ "medium", ## if longer than 6s but less than 8s, label medium
    minutes_per_mile > 8 ~ "slow")) %>%  ## if longer than 8s, label slow
  mutate(form = case_when(
    year == 2024 ~ "new", ## if year = 2024, label new
    year <= 2023 ~ "old")) ## if year 2023 or older, label old


#5. Identify the average steps per minute for laps by form and pace, and generate a table showing these values with old and new as separate rows and pace categories as columns. Make sure that slow speed is the second column, medium speed is the third column, and fast speed is the fourth column (hint: think about what the select() function does).

avg_steps <- data_filtered %>% 
  group_by(form, pace) %>% 
  summarize(avg_steps_per_min = mean(steps_per_minute)) %>% ## summary table of avg steps by form & pace
  pivot_wider(id_cols = form, 
              names_from = pace, 
              values_from = avg_steps_per_min) %>% ## flip form & pace to columns
  select(form, slow, medium, fast) ## ordering columns


#6. Finally, Tyler thinks he’s been doing better since July after the doctors filmed him running again and provided new advice. Summarize the minimum, mean, median, and maximum steps per minute results for all laps (regardless of pace category) run between January - June 2024 and July - October 2024 for comparison.

jan_june_2024 <- data_filtered %>% ## dataframe with only jan-june 2024
  filter(year == 2024,
         month %in% 1:6)

july_oct_2024 <- data_filtered %>% ## dataframe with only july- oct 2024
  filter(year == 2024,
         month %in% 7:10)

summary(jan_june_2024$steps_per_minute) ## summaries
summary(july_oct_2024$steps_per_minute)
