# To remove object from environment
x <- 1
rm(x)  ## one object
rm(list = ls())  ## all objects

    
# Comparison fcns (T/F output)
mynumber <- 6
mynumber == 4  ## are these values the same?
mynumber != 4  ## are these values different?
mynumber >= 4  ## greater/less than or equal to 


# Object name conventions
numSamples <- 5   ## option 1: lowercase first word, uppercase all other words
num_samples <- 5  ## option 2: lowercase all, separate by _


# CHALLENGE
elephant1_kg <- 3492
elephant2_lbs <- 7757

elephant1_lbs <- elephant1_kg * 2.2
myelephants <- c(elephant1_lbs, elephant2_lbs)
which(myelephants == max(myelephants))  ## max value in vector


