#1. Create a tibble named surveys from the portal_data_joined.csv file. Then manipulate surveys to create a new dataframe called surveys_wide with a column for genus and a column named after every plot type, with each of these columns containing the mean hindfoot length of animals in that plot type and genus. So every row has a genus and then a mean hindfoot length value for every plot type. The dataframe should be sorted by values in the Control plot type column. This question will involve quite a few of the functions you’ve used so far, and it may be useful to sketch out the steps to get to the final result.

library(tidyverse)
surveys <- read_csv('data/portal_data_joined.csv')

surveys_wide <- surveys %>% 
  filter(!is.na(hindfoot_length)) %>% ## filter out NAs
  group_by(genus, plot_type) %>% 
  summarise(avg_hindfoot_length = mean(hindfoot_length)) %>% ## summary of mean hindfoot length by genus/plot type
  ungroup() %>% 
  pivot_wider(id_cols = 'genus', 
              names_from = 'plot_type',
              values_from = 'avg_hindfoot_length') %>% ## widen dataframe
  arrange(Control) ## arrange by column "Control"

colnames(surveys_wide)
unique(surveys$plot_type) ## checking all plot types got turned into columns


#2. Using the original surveys dataframe, use the two different functions we laid out for conditional statements, ifelse() and case_when(), to calculate a new weight category variable called weight_cat. For this variable, define the rodent weight into three categories, where “small” is less than or equal to the 1st quartile of weight distribution, “medium” is between (but not inclusive) the 1st and 3rd quartile, and “large” is any weight greater than or equal to the 3rd quartile. (Hint: the summary() function on a column summarizes the distribution). For ifelse() and case_when(), compare what happens to the weight values of NA, depending on how you specify your arguments.

summary(surveys$weight)

surveys <- surveys %>% 
  mutate(weight_cat_casewhen = case_when(
    weight <= 20 ~ "small", 
    weight < 48.00 ~ "medium", # can be "weight > 20.00 & weight < 48.00 ~ "medium"," so you dont have to worry about order
    weight >= 48 ~ "large"))

surveys <- surveys %>% 
  mutate(weight_cat_ifelse = ifelse(weight <= 20.00, "small",
                                    ifelse(weight > 20.00 & weight < 48.00, "medium","large")))
  
#BONUS: How might you soft code the values (i.e. not type them in manually) of the 1st and 3rd quartile into your conditional statements in question 2?
summary_weight <- summary(surveys$weight)
summary_weight[[2]]
summary_weight[[5]]

surveys <- surveys %>% 
  mutate(weight_cat_bonus = case_when(
    weight <= summary_weight[[2]] ~ "small", 
    weight < summary_weight[[5]] ~ "medium", 
    weight >= summary_weight[[5]] ~ "large"))
