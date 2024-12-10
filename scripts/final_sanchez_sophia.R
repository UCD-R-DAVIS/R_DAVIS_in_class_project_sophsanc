library(tidyverse)

#1. Read in the file tyler_activity_laps_12-6.csv from the class github page.
data <- read.csv("https://raw.githubusercontent.com/UCD-R-DAVIS/R-DAVIS/refs/heads/main/data/tyler_activity_laps_12-6.csv")

#2. Filter out any non-running activities.
#3. We are interested in normal running. You can assume that any lap with a pace above 10 minutes_per_mile pace is walking, so remove those laps. You should also remove any abnormally fast laps (< 5 minute_per_mile pace) and abnormally short records where the total elapsed time is one minute or less.
#4. Group observations into three time periods corresponding to pre-2024 running, Tyler’s initial rehab efforts from January to June of this year, and activities from July to the present.

data <- data %>% 
  filter(sport == 'running',  # question 2 
         minutes_per_mile < 10, # question 3 
         minutes_per_mile > 5,
         total_elapsed_time_s > 60) %>% 
  mutate(time_period = case_when ( # question 4
    year < 2024 ~ "pre_2024", 
    year == 2024 & month >= 1 & month <= 6 ~ "initial_rehab", 
    year == 2024 & month > 6 ~ "post_rehab"
  ))

unique(data$sport)
summary(data)
unique(data$time_period)

#5. Make a scatter plot that graphs SPM over speed by lap.
#6. Make 5 aesthetic changes to the plot to improve the visual.
#7. Add linear (i.e., straight) trendlines to the plot to show the relationship between speed and SPM for each of the three time periods (hint: you might want to check out the options for geom_smooth())

color_palette <- c("lightblue", "mediumblue","navyblue")

scatter_plot <- data %>% 
  ggplot(mapping = aes(x = minutes_per_mile, y = steps_per_minute, color = time_period)) + # question 5
  geom_point(alpha = 0.2) + # question 6.1 
  geom_smooth(method = lm, se = FALSE) + # question 7
  xlab("Minutes Per Mile (Speed)") + # question 6.2
  ylab("Steps Per Minute (SPM)") +
  ggtitle("Steps-per-minute over speed by lap") + # question 6.3
  scale_color_manual(values = color_palette) + # question 6.4
  theme_minimal() # question 6.5

scatter_plot

#8. Does this relationship maintain or break down as Tyler gets tired? Focus just on post-intervention runs (after July 1, 2024). Make a plot (of your choosing) that shows SPM vs. speed by lap. Use the timestamp indicator to assign lap numbers, assuming that all laps on a given day correspond to the same run (hint: check out the rank() function). Select only laps 1-3 (Tyler never runs more than three miles these days). Make a plot that shows SPM, speed, and lap number (pick a visualization that you think best shows these three variables).

plot2 <- data %>% 
  filter(time_period == "post_rehab") %>% 
  group_by(year, day, month) %>% 
  mutate(lap = rank(timestamp)) %>% 
  ungroup %>% 
  filter(lap %in% 1:3) %>% 
  ggplot(mapping = aes(x = minutes_per_mile, y = steps_per_minute)) +
  geom_point(alpha=0.8) +
  geom_smooth(method = lm, se = FALSE) +
  xlab("Minutes Per Mile (Speed)") +
  ylab("Steps Per Minute (SPM)") +
  ggtitle("Steps-per-minute over speed by lap number") +
  theme_classic() +
  facet_wrap(~lap)
  
  plot2
