# Load your survey data frame with the read.csv() function. 
surveys <- read.csv("data/portal_data_joined.csv")

# Create a new data frame called surveys_base with only the species_id, the weight, and the plot_type columns. Have this data frame only be the first 5,000 rows. 
colnames(surveys)
surveys_base <- surveys[1:5000, c(6,9,13)] # can also do with column names

# Convert both species_id and plot_type to factors.
surveys_base$species_id <- factor(surveys_base$species_id)
surveys_base$plot_type <- factor(surveys_base$plot_type)
str(surveys_base)

# Remove all rows where there is an NA in the weight column. 
surveys_base <- surveys_base[complete.cases(surveys_base), ]

# Explore these variables and try to explain why a factor is different from a character. Why might we want to use factors? Can you think of any examples?
levels(surveys_base$species_id) ## factors convert values into alphabetically-ordered "levels"
nlevels(surveys_base$species_id)
typeof(surveys_base$species_id) ## unlike characters, each value is assigned an integer value
  ## Uses: ranking groups, treat groups as categorical variables 

#CHALLENGE: Create a second data frame called challenge_base that only consists of individuals from your surveys_base data frame with weights greater than 150g.
challenge_base <- surveys_base[surveys_base[, 2] > 150 , ]

