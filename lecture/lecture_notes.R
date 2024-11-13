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






############# WEEK 6 ##################################################################################################





library(tidyverse)

# ggplot2 ----
## included in tidyverse package - you can see this when you call library(tidyverse)
## easy to use functions to produce pretty plots
## ?ggplot2 will take you to the package helpfile where there is a link to the website: https://ggplot2.tidyverse.org - this is where you'll find the cheatsheet with visuals of what the package can do!

## ggplot basics
## every plot can be made from these three components: data, the coordinate system (ie what gets mapped), and the geoms (how to graphical represent the data)
## Syntax: ggplot(data = <DATA>) + <GEOM_FUNCTION>(mapping = aes(<MAPPING>))
  # notice ggplot uses + instead of pipe

## tips and tricks
## think about the type of data and how many data  variables you are working with -- is it continuous, categorical, a combo of both? is it just one variable or three? this will help you settle on what type of geom you want to plot
## order matters! ggplot works by layering each geom on top of the other
## also aesthetics like color & size of text matters! make your plots accessible 


## example ----
library(tidyverse)
## load in data
surveys <- read_csv("data/portal_data_joined.csv") %>%
  filter(complete.cases(.)) # remove all NA's

## Let's look at two continuous variables: weight & hindfoot length
## Specific geom settings
ggplot(data = surveys, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point(aes(color = genus)) +
  geom_smooth() + ## line of best fit for all points
  geom_smooth(aes(color = genus)) ## line of best fit by genus
  

## Universal geom settings 
    ## putting color in ggplot mapping aes makes it so that all the following geoms apply by that group (equivalent of adding the aes color in each geom)
ggplot(data = surveys, mapping = aes(x = weight, y = hindfoot_length, color = genus)) +
  geom_point() +
  geom_smooth()

ggplot(data = surveys, mapping = aes(x = weight, y = hindfoot_length, color = genus)) +
  geom_point(color = "blue") + # color without aes just determines colors of all dots
  geom_smooth()


## Visualize weight categories and the range of hindfoot lengths in each group
## Bonus from hw: 
sum_weight <- summary(surveys$weight)
surveys_wt_cat <- surveys %>% 
  mutate(weight_cat = case_when(
    weight <= sum_weight[[2]] ~ "small", 
    weight > sum_weight[[2]] & weight < sum_weight[[5]] ~ "medium",
    weight >= sum_weight[[5]] ~ "large"
  )) 

table(surveys_wt_cat$weight_cat)


## We have one categorical variable and one continuous variable - what type of plot is best?
ggplot(data = surveys_wt_cat, aes(x = weight_cat, y = hindfoot_length)) +
  geom_boxplot(aes(color = weight_cat), alpha = 0.5) + ## alpha = transparency 
  geom_point(alpha = 0.1)

## What if I want to switch order of weight_cat? factor!
surveys_wt_cat$weight_cat <- factor(surveys_wt_cat$weight_cat, c("small", "medium", "large"))

ggplot(data = surveys_wt_cat, aes(x = weight_cat, y = hindfoot_length)) +
  geom_jitter(alpha = 0.1) + # geom_jitter spreads the points of geom_point out
  geom_boxplot(aes(color = weight_cat), alpha = 0.5)  ## alpha = transparency 
    # notice that order changes the layer order 


# these are two different ways of doing the same thing
surveys_complete <- read_csv("data/portal_data_joined.csv") %>%
  filter(complete.cases(.)) # remove all NA's

head(surveys_complete %>% count(year,species_id))
head(surveys_complete %>% group_by(year,species_id) %>% tally())

yearly_counts <- surveys_complete %>% count(year,species_id)
head(yearly_counts)

# grouping variables
ggplot(data = yearly_counts,mapping = aes(x = year, y= n)) +
  geom_line() # BAD! this draws a single line from the highest/lowest points per year regardless of species

ggplot(data = yearly_counts,mapping = aes(x = year, y= n,group = species_id)) +
  geom_line() # GOOD! now it does lines by species, but all same color

ggplot(data = yearly_counts,mapping = aes(x = year, y= n, colour = species_id)) +
  geom_line() # BETTER! lines by species, different colors. but colors are really similar and hard to read...

#Facet-wrap
 ggplot(data = yearly_counts, mapping = aes(x = year, y = n)) +
  geom_line() +
  facet_wrap(~ species_id) # BETTER BETTER!! facet_wrap seperates each panel by group

ggplot(data = yearly_counts, mapping = aes(x = year, y = n)) +
  geom_line() +
  facet_wrap(~ species_id,scales = 'free') #scales=free adds individual, different axis to each 

ggplot(data = yearly_counts[yearly_counts$species_id%in%c('BA', 'DM', 'DO', 'DS'),], mapping = aes(x = year, y = n, group = species_id)) + #how to subset for just few groups
  geom_line() +
  facet_wrap(~ species_id,scales = 'free') +
  scale_y_continuous(name='observations', breaks = seq(0,600,100)) + #how to change y axis, same for x 
  theme_bw() #theme impacts general appearance 

# Maps 

library(tigris)
library(sf)

ca_counties = tigris::counties(state='CA', class='sf', year = 2023)
ggplot(data=ca_counties) + geom_sf(aes(fill = AWATER))  





########### WEEK 7 ####################################################################


library(tidyverse)
library(ggplot2)

#Section 1: Plot Best Practices and GGPlot Review####
#ggplot has four parts:
#data / materials   ggplot(data=yourdata)
#plot type / design   geom_...
#aesthetics / decor   aes()
#stats / wiring   stat_...

#Let's see what this looks like:

#Here we practice creating a dot plot of price on carat
#all-over color
ggplot(diamonds, aes(x= carat, y= price)) +
  geom_point(color="blue")
#color by variable
ggplot(diamonds, aes(x= carat, y= price, color=clarity)) +
  geom_point(alpha = 0.2)

#plot best practices:
#remove backgrounds, redundant labels, borders, reduce colors and special effects, remove bolding, lighten labels, remove lines, direct label

#Now I've removed the background to clean up the plot, and added a title and edited the y label to be more specific
ggplot(diamonds, aes(x= carat, y= price, color=clarity)) +
  geom_point(alpha = 0.2) + theme_classic() + 
  ggtitle("Price by Diamond Quality") + ylab("price in $")

#Now I've added linear regression trendlines for each color
ggplot(diamonds, aes(x= carat, y= price, color=clarity)) +
  geom_point(alpha = 0.2) + theme_classic() + 
  ggtitle("Price by Diamond Quality") + ylab("price in $") + 
  stat_smooth(method = "lm")

#Now I've instead added LOESS trendcurves for each color
ggplot(diamonds, aes(x= carat, y= price, color=clarity)) +
  geom_point(alpha = 0.2) + theme_classic() + 
  ggtitle("Price by Diamond Quality") + ylab("price in $") + 
  stat_smooth(method = "loess")


#Section 2 Color Palette Choices and Color-Blind Friendly Visualizations ####

#always work to use colorblind-friendly or black-and-white friendly palettes

#There are four types of palettes: 
#1: continuous
#2: ordinal (for plotting categories representing least to most of something, with zero at one end)
#3: qualitative (for showing different categories that are non-ordered)
#4: diverging (for plotting a range from negative values to positive values, with zero in the middle)

#RColorBrewer shows some good examples of these. Let's take a look.
library("RColorBrewer")
#This is a list of all of RColorBrewer's colorblind-friendly discrete color palettes 
display.brewer.all(colorblindFriendly = TRUE)

#CONTINUOUS DATA
#use scale_fill_viridis_c or scale_color_viridis_c for continuous
#I set direction = -1 to reverse the direction of the colorscale.
ggplot(diamonds, aes(x= clarity, y= carat, color=price)) +
  geom_point(alpha = 0.2) + theme_classic() +
  scale_color_viridis_c(option = "A", direction = 1)

#let's pick another viridis color scheme by using a different letter for option
ggplot(diamonds, aes(x= clarity, y= carat, color=price)) +
  geom_point(alpha = 0.2) + theme_classic() +
  scale_color_viridis_c(option = "E", direction = -1)

#to bin continuous data, use the suffix "_b" instead
ggplot(diamonds, aes(x= clarity, y= carat, color=price)) +
  geom_point(alpha = 0.2) + theme_classic() +
  scale_color_viridis_b(option = "C", direction = -1)

#ORDINAL (DISCRETE SEQUENTIAL) 
#from the viridis palette, use scale_fill_viridis_d or scale_color_viridis_d for discrete, ordinal data
ggplot(diamonds, aes(x= cut, y= carat, fill = color)) +
  geom_boxplot() + theme_classic() + 
  ggtitle("Diamond Quality by Cut") + 
  scale_fill_viridis_d("color")

#scale_color is for color and scale_fill is for the fill. 
#note I have to change the aes parameter from "fill =" to "color =", to match
ggplot(diamonds, aes(x= cut, y= carat, color = color)) +
  geom_boxplot(alpha = 0.2) + theme_classic() + 
  ggtitle("Diamond Quality by Cut") + 
  scale_color_viridis_d("color")

#here's how it looks on a barplot
ggplot(diamonds, aes(x = clarity, fill = cut)) + 
  geom_bar() +
  theme(axis.text.x = element_text(angle=70, vjust=0.5)) +
  scale_fill_viridis_d("cut", option = "B") +
  theme_classic()

#from RColorBrewer:
ggplot(diamonds, aes(x= cut, y= carat, fill = color)) +
  geom_boxplot() + theme_classic() + 
  ggtitle("Diamond Quality by Cut") + 
  scale_fill_brewer(palette = "PuRd")
#how did we know the name of the palette is "PuRd"? From this list:
display.brewer.all(colorblindFriendly = TRUE)

#QUALITATIVE CATEGORICAL

#From RColorBrewer:
ggplot(iris, 
       aes(x= Sepal.Length, y= Petal.Length, fill = Species)) +
  geom_point(shape=24, color="black") + theme_classic() + 
  ggtitle("Sepal and Petal Length of Three Iris Species") + 
  scale_fill_brewer(palette = "Set2")


#From the ggthemes package: let's also clarify the units
library(ggthemes)
ggplot(iris, aes(x= Sepal.Length, y= Petal.Length, color = Species)) +
  geom_point() + theme_classic() + 
  ggtitle("Sepal and Petal Length of Three Iris Species") + 
  scale_color_colorblind("Species") +
  xlab("Sepal Length in cm") + 
  ylab("Petal Length in cm")

#Manual Palette Design
#this is another version of the same 
#colorblind palette from the ggthemes package but with gray instead of black.
#This is an example of how to create a named vector
#of colors and use it as a manual fill.
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
names(cbPalette) <- levels(iris$Species)
#we don't need all the colors in the palette because there are only 3 categories. 
#We cut the vector length to 3 here
cbPalette <- cbPalette[1:length(levels(iris$Species))]

ggplot(iris, aes(x= Sepal.Length, y= Petal.Length, color = Species)) +
  geom_point() + theme_classic() + 
  ggtitle("Sepal and Petal Length of Three Iris Species") + 
  scale_color_manual(values = cbPalette) +
  xlab("Sepal Length in cm") + 
  ylab("Petal Length in cm")

#DIVERGING DISCRETE
#from RColorBrewer
myiris <- iris %>% group_by(Species) %>% mutate(size = case_when(
  Sepal.Length > 1.1* mean(Sepal.Length) ~ "very large",
  Sepal.Length < 0.9 * mean(Sepal.Length) ~ "very small",
  Sepal.Length < 0.94 * mean(Sepal.Length) ~ "small",
  Sepal.Length > 1.06 * mean(Sepal.Length) ~ "large",
  T ~ "average"
  
))
myiris$size <- factor(myiris$size, levels = c(
  "very small", "small", "average", "large", "very large"
))

ggplot(myiris, aes(x= Petal.Width, y= Petal.Length, color = size)) +
  geom_point(size = 2) + theme_gray() +
  ggtitle("Diamond Quality by Cut") + 
  scale_color_brewer(palette = "RdYlBu")

#Paul Tol also has developed qualitative, sequential, and diverging colorblind palettes:
#https://cran.r-project.org/web/packages/khroma/vignettes/tol.html
#you can enter the hex codes in manually just like the cbPalette example above


#also check out the turbo color palette!
#https://docs.google.com/presentation/d/1Za8JHhvr2xD93V0bqfK--Y9GnWL1zUrtvxd_y9a2Wo8/edit?usp=sharing
#https://blog.research.google/2019/08/turbo-improved-rainbow-colormap-for.html

#to download it and use it in R, use this link
#https://rdrr.io/github/jlmelville/vizier/man/turbo.html


#Section 3: Non-visual representations ####
#Braille package
mybarplot <- ggplot(diamonds, aes(x = clarity)) + 
  geom_bar() +
  theme(axis.text.x = element_text(angle=70, vjust=0.5)) +
  theme_classic() + ggtitle("Number of Diamonds by Clarity")
mybarplot

library(BrailleR)

VI(mybarplot)

library(sonify)
plot(iris$Petal.Width)
sonify(iris$Petal.Width)

detach("package:BrailleR", unload=TRUE)

#Section 4: Publishing Plots and Saving Figures & Plots ####
library(cowplot)
#you can print multiple plots together, 
#which is helpful for publications
# make a few plots:
plot.diamonds <- ggplot(diamonds, aes(clarity, fill = cut)) + 
  geom_bar() +
  theme(axis.text.x = element_text(angle=70, vjust=0.5))
#plot.diamonds

plot.cars <- ggplot(mpg, aes(x = cty, y = hwy, colour = factor(cyl))) + 
  geom_point(size = 2.5)
#plot.cars

plot.iris <- ggplot(data=iris, aes(x=Sepal.Length, y=Petal.Length, fill=Species)) +
  geom_point(size=3, alpha=0.7, shape=21)
#plot.iris

# use plot_grid
panel_plot <- plot_grid(plot.cars, plot.iris, plot.diamonds, 
                        labels=c("A", "B", "C"), ncol=2, nrow = 2)

panel_plot

#you can fix the sizes for more control over the result
fixed_gridplot <- ggdraw() + draw_plot(plot.iris, x = 0, y = 0, width = 1, height = 0.5) +
  draw_plot(plot.cars, x=0, y=.5, width=0.5, height = 0.5) +
  draw_plot(plot.diamonds, x=0.5, y=0.5, width=0.5, height = 0.5) + 
  draw_plot_label(label = c("A","B","C"), x = c(0, 0.5, 0), y = c(1, 1, 0.5))

fixed_gridplot

#saving figures
ggsave("figures/gridplot.png", fixed_gridplot)
#you can save images as .png, .jpeg, .tiff, .pdf, .bmp, or .svg

#for publications, use dpi of at least 700
ggsave("figures/gridplot.png", fixed_gridplot, 
       width = 6, height = 4, units = "in", dpi = 700)

#interactive web applications
library(plotly)

plot.iris <- ggplot(data=iris, aes(x=Sepal.Length, y=Petal.Length, 
                                   fill=Species)) +
  geom_point(size=3, alpha=0.7, shape=21)

plotly::ggplotly(plot.iris)

