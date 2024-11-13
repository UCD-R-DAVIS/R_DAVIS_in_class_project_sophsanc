library(tidyverse)
library(ggplot2)
gapminder <- read_csv("https://ucd-r-davis.github.io/R-DAVIS/data/gapminder.csv")


gapminder_filtered <- gapminder %>% 
  select(year, pop, country,continent) %>% 
  filter(year %in% c(2002,2007)) %>% 
  pivot_wider(names_from = year, values_from = pop) %>% 
  mutate(pop_2002_2007 = `2007` - `2002`)

unique(gapminder_filtered$continent)

plot <- gapminder_filtered %>% 
  filter(continent %in% c('Africa', 'Americas', 'Asia', 'Europe')) %>% 
  ggplot(aes(x = reorder(country, pop_2002_2007), y = pop_2002_2007)) +
  geom_col(aes(fill = continent)) +
  theme_bw() +
  scale_fill_viridis_d() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), 
        legend.position = "none") +
  xlab("Country") +
  ylab("Change in Population Between 2002 and 2007") +
  facet_wrap(~continent, scales = "free") 

plot