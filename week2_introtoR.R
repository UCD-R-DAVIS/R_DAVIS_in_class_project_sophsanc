########### PROJECT MGMT ###################

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



########### HOW R THINKS ABOUT DATA ###################

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





