###########   WEEK 2   ###################################################################################

# Remove object from environment ----
x <- 1
rm(x)  ## one object
rm(list = ls())  ## all objects

    
# Comparison fcns (T/F output) ----
mynumber <- 6
mynumber == 4  ## are these values the same?
mynumber != 4  ## are these values different?
mynumber >= 4  ## greater/less than or equal to 


# Object name conventions ----
numSamples <- 5   ## option 1: lowercase first word, uppercase all other words
num_samples <- 5  ## option 2: lowercase all, separate by _


# Challenge ----
elephant1_kg <- 3492
elephant2_lbs <- 7757

elephant1_lbs <- elephant1_kg * 2.2
myelephants <- c(elephant1_lbs, elephant2_lbs)
which(myelephants == max(myelephants))  ## max value in vector

# Working directory & file paths ----
getwd()  ## check WD
setwd()  ## change WD
data <- read.csv("./data/filename.csv") ## shortcut pulling data
dir.create("./lecture")  ## create new folder in WD, comment out after to avoid warning
dir.create("./assignments")

# Vectors & Subsetting----
vector <- c(1,2,3) 
vector2 <- c("dog", "cat", "fish")

length(vector)  ## number of values
str(vector)  ## list of values

vector <- c(vector, 4)  ## adding new value to vector

vector2[1]  ## [n] produces value in the nth position of vector
vector2[c(1,2)]
vector[vector > 2]  ## conditional subsetting, only produces values meeting criteria

# Conditional Symbols ----
vector2
vector2 %in% c("duck", "dog", "fish") ## checking if values exist in vector2, order doesn't matter
vector2 == c("cat", "dog", "fish") ## checking if values exist in exact same order

# Challenge 1 ----
 ## In a mixed class vector, the entire vector will be the class of the "dominant" class: characters --> numeric --> logical (T/F)
 ## So: vectors need to be all the same class. 
num_char <- c(1, 2, 3, "a") 
num_logical <- c(1, 2, 3, TRUE)  ## class: numeric, logical entries become binary (T/F --> 0/1)
char_logical <- c("a", "b", "c", TRUE)
tricky <- c(1, 2, 3, "4") 
combined_logical <- c(num_logical, char_logical)



###########   WEEK 3   ###################################################################################

# Other data types ----

## Lists 
a <- list(4,6,"dog")

## Data.frames
letters 
df <- data.frame(letters)
ncol(df) # number columns
nrow(df) # number columns
dim(df) # dimensions (number rows, columns)

## Factors 
animals <- factor(c("duck", "duck", "goose", "goose")) # characters example
animals # levels numbered in alphabetical order
levels(animals) 
nlevels(animals)
animals <- factor(x = animals, levels = c("goose", "pigs", "duck"))

year <- factor(c(1978,1980,1934,1979)) # numbers example
levels(year) # levels ordered numerically --> can get super messy
as.numeric(year) # tells you the print order of the values 



# Spreadsheets ----
file_loc <- 'data/portal_data_joined.csv' # can save location path as object
surveys <- read.csv(file_loc) # reading in csv 
# alternate: surveys <- read.csv("data/portal_data_joined.csv") # reading in csv
class(surveys)
str(surveys) # can use to see your columns, their classes, etc
summary(surveys) # calls summary command on every column --> min, 1st quart, median, mean. 3rd quart, max
nrow(surveys)
ncol(surveys)
colnames(surveys) # column names 

surveys[1,5] # outputs value at position [row,column]
surveys[1:5,] # returns all columns for rows 1-5
surveys[,1:5] # returns all rows but only values in columns 1-5

head(surveys) # outputs first 6 rows of data, can adjust # rows or columns: head(surveys[,])
tail(surveys) # outputs last 6 rows of data, can adjust # rows or columns: tail(surveys[,])
head(surveys["genus"]) # outputs first 6 rows in specific column --> SUBSET OF COLUMNS
head(surveys[["genus"]]) # outputs first 6 rows from specific column AS A VECTOR, extracts specific value
# double bracket --> pulls data from that second level 
head(surveys[,"genus"]) # does same as double braket above 

surveys$record_id # pulling specific column values 



###########   WEEK 4   ###################################################################################

#benefits of tidyverse
#1. Predictable results (base R functionality can vary by data type) 
#2. Good for new learners, because syntax is consistent. 
#3. Avoids hidden arguments and default settings of base R functions

#To load the package type:
library(tidyverse)

surveys <- read_csv("data/portal_data_joined.csv")

str(surveys)

#select columns
month_day_year <- select(surveys, month, day, year)

#filtering by equals -- rows
year_1981 <- filter(surveys, year == 1981)
sum(year_1981$year != 1981, na.rm = TRUE)

#filtering by range -- rows
the80s <- surveys[surveys$year %in% 1981:1983,] ## base R way
filter(surveys, year %in% 1981:1983) ## tidyverse way
#5033 results


#review: why should you NEVER do:
the80srecycle <- filter(surveys, year == c(1981:1983))
#1685 results
#This recycles the vector (index-matching, not bucket-matching). If you ever really need to do that for some reason, comment it ~very~ clearly and explain why you're recycling!

#filtering by multiple conditions
bigfoot_with_weight <- filter(surveys, hindfoot_length > 40 & !is.na(weight))

#multi-step process: this is slightly dangerous because you have to remember to select from small_animals, not surveys in the next step
small_animals <- filter(surveys, weight < 5)
small_animal_ids <- select(small_animals, record_id, plot_id, species_id)

#same process, using nested functions. also messy. 
small_animal_ids <- select(filter(surveys, weight < 5), record_id, plot_id, species_id)

#same process, using a pipe: 
small_animal_ids <- filter(surveys, weight < 5) %>% 
  select(record_id, plot_id, species_id)

#same as
small_animal_ids <- surveys %>% 
  filter(weight < 5) %>% 
  select(record_id, plot_id, species_id)
#line break rules: after open parenthesis, pipe, commas, or anything that shows the line is not complete yet


#one final review of an important concept we learned last week
#applied to the tidyverse

mini <- surveys[190:209,]
table(mini$species_id)
#how many rows have a species ID that's either DM or NL?
nrow(mini)

mini %>% filter(species_id %in% c("DM", "NL"))


########## part 1b ##############

# mutate fcn: adds new column
surveys <- surveys %>% 
  mutate(weight_kg = weight/1000)

surveys <- surveys %>% ## adding multiple columns
  mutate(
    weight_kg = weight/1000, 
    weight_kg2 = weight_kg *2)

ave_weight <- surveys %>% ## doing multiple fcns in one pipe
  filter(!is.na(weight)) %>% 
  mutate(mean_weight = mean(weight))


# group_by & summarize
surveys %>% 
  group_by(sex, species_id) %>%
  filter(!is.na(sex)) %>% 
  summarise(mean_weight = mean(weight, na.rm = TRUE)) %>% 
  arrange(mean_weight)

# sort/arrange data
arranged <- surveys %>% 
  group_by(sex, species_id) %>% 
  # filter(sex!= "") %>% 
  filter(!is.na(sex)) %>% 
  summarise(mean_weight = mean(weight, na.rm = TRUE)) %>% 
  arrange(-mean_weight) #automatically does ascending --> add - before column to arrange descending


# Challenge
#What was the weight of the heaviest animal measured in each year? 
#Return a table with three columns: year, weight of the heaviest animal in grams, and weight in kilograms, 
#arranged (arrange()) in descending order, from heaviest to lightest. (This table should have 26 rows, one for each year)

challenge1 <- surveys %>% 
  select(year, record_id, weight) %>% 
  filter(!is.na(weight)) %>% 
  mutate(weight_kg = weight/1000) %>% 
  group_by(year) %>% 
  summarise(max_weight_g = max(weight),
            max_weight_kg = max(weight_kg)) %>% 
  arrange(-max_weight_g)



#Try out a new function, count(). Group the data by sex and pipe the grouped data into the count() function. How could you get the same result using group_by() and summarize()? Hint: see ?n.





###########   WEEK 5  ###################################################################################

# Conditional statements ---- 
## ifelse: run a test, if true do this, if false do this other thing
## case_when: basically multiple ifelse statements
# can be helpful to write "psuedo-code" first which basically is writing out what steps you want to take & then do the actual coding
# great way to classify and reclassify data

## Load library and data ----
library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv")

## ifelse() ----
# from base R
# ifelse(test, what to do if yes/true, what to do if no/false)
## if yes or no are too short, their elements are recycled
## missing values in test give missing values in the result
## ifelse() strips attributes: this is important when working with Dates and factors



## case_when() ----
# GREAT helpfile with examples!
# from tidyverse so have to use within mutate()
# useful if you have multiple tests
## each case evaluated sequentially & first match determines corresponding value in the output vector
## if no cases match then values go into the "else" category
## NAs stay as NAs !!!!
surveys$hindfoot_cat <- ifelse(surveys$hindfoot_length < mean(surveys$hindfoot_length, na.rm = TRUE), 
                               yes = "small", no = "big")
unique(surveys$hindfoot_cat)

# case_when() equivalent of what we wrote in the ifelse, more customization
# if no "else" category specified, then the output will be NA
# NAs get labeled as the else. they dont stay as NAs !!!!
surveys %>%
  mutate(hindfoot_cat = case_when(
    hindfoot_length > 29.29 ~ "big", ## if length > than 29.29, then classify as "big"
    TRUE ~ "small")) %>% ## the else; basically if length = or < 29.29, then classify as "small"
  select(hindfoot_length, hindfoot_cat) %>%
  head()

surveys %>% 
  mutate(hindfoot_cat = case_when(
    hindfoot_length > 31.5 ~ "big",
    hindfoot_length > 29 ~ "medium", 
    is.na(hindfoot_length) ~ NA_character_, # if NA, print as NA
    TRUE ~ "small")) %>% # catch-all, if value doesnt apply to the previous statements then labeled as small
  select(hindfoot_cat, hindfoot_length)


# lots of other ways to specify cases in case_when and ifelse
surveys %>%
  mutate(favorites = case_when(
    year < 1990 & hindfoot_length > 29.29 ~ "number1", 
    species_id %in% c("NL", "DM", "PF", "PE") ~ "number2",
    month == 4 ~ "number3",
    TRUE ~ "other"
  )) %>%
  group_by(favorites) %>%
  tally()


### Join Functions
#inner_join -- will return all the rows from Table A that has matching values in Table B, and all the columns from both Table A and B

#left_join -- returns all the rows from Table A with all the columns from both A and B. Rows in Table A that have no match in Table B will return NAs

#right_join -- returns all the rows from Table B and all the columns from table A and B. Rows in Table B that have no match in Table A will return NAs. recommend not using this, just flip DF order in left_join

#full_join -- returns all the rows and all the columns from Table A and Table B. Where there are no matching values, returns NA for the one that is missing.

# tip: use dim() & nrow() to see dimensions of joins to make sure its doing what you want

# tip: can rename columns using rename() to make column names the same 

library(tidyverse)
tail <- read_csv("data/tail_length.csv")
rm(surveys)
surveys <- read_csv("data/portal_data_joined.csv")

surveys_inner <- inner_join(x = surveys, y = tail)
dim(surveys_inner)
head(surveys_inner)

surveys_left <- left_join(x = surveys, y = tail)
dim(surveys_left)

surveys_full_join <- full_join(x = surveys, y = tail)
dim(surveys_full_join)


# Pivot Functions
# pivot_wider() widens data by increasing the number of columns and decreasing the number of rows. It takes three main arguments: (1) the data, (2) names_from the name of the column you’d like to spread out, (3) values_from the data you want to fill all your new columns with

#pivot_longer lengthens data by increasing the number of rows and decreasing the number of columns. This function takes 4 main arguments: (1) the data, (2) cols, the column(s) to be pivoted (or to ignore), (3) names_to the name of the new column you’ll create to put the column names in, (4) values_to the name of the new column to put the column values in

surveys_mz <- surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(genus, plot_id) %>% 
  summarize(mean_weight = mean(weight)) 

surveys_mz %>% pivot_wider(id_cols = 'genus',
                           names_from = 'plot_id', 
                           values_from = 'mean_weight')


