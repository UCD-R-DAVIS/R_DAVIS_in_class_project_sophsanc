library(tidyverse)
gapminder <- read_csv("https://ucd-r-davis.github.io/R-DAVIS/data/gapminder.csv")

#1. First calculates mean life expectancy on each continent. Then create a plot that shows how life expectancy has changed over time in each continent. Try to do this all in one step using pipes! (aka, try not to create intermediate dataframes)

gapminder %>% 
  group_by(continent,year) %>% 
  mutate(avg_life_exp = mean(lifeExp)) %>% 
  ungroup %>% 
  ggplot(data = ., mapping = (aes(x = year, y = avg_life_exp, color = continent))) +
  geom_point() +
  geom_line() 

#2. Look at the following code and answer the following questions. What do you think the scale_x_log10() line of code is achieving? What about the geom_smooth() line of code?

    ## scale_x_log10() log transforms the x-axis 
    ## geom_smooth() is using a linear model to find the line of best fit through all the 
       ##data. the line is black and dashed. 

# Challenge! Modify the above code to size the points in proportion to the population of the country

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color = continent, size = pop)) + 
  scale_x_log10() +
  geom_smooth(method = 'lm', color = 'black', linetype = 'dashed') +
  theme_bw()

#3. Create a boxplot that shows the life expectency for Brazil, China, El Salvador, Niger, and the United States, with the data points in the backgroud using geom_jitter. Label the X and Y axis with “Country” and “Life Expectancy” and title the plot “Life Expectancy of Five Countries”.

unique(gapminder$country)

gapminder %>% 
  filter(country %in% c('Brazil', 'China', 'El Salvador', 'Niger', "United States")) %>% 
  ggplot(data = ., mapping = aes(x = country, y = lifeExp)) +
  geom_boxplot() +
  geom_jitter(alpha = 0.2) +
  xlab('Country') +
  ylab('Life Expectancy') +
  ggtitle("Life Expectancy of Five Countries")
  
