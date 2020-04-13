# Loading dependencies ----------------------------------------------------

# install.packages(c('tidyverse', 'lubridate', 'geojsonio','broom','maps','transformr','viridis','gganimate'))
library(tidyverse)
library(lubridate)
library(geojsonio)
library(broom)
library(maps)
library(transformr)
library(viridis)
library(gganimate)



# Reading in and tidying data ---------------------------------------------

# Reading in Michigan map data (https://michiganradioweb.carto.com/tables/michigan_counties/public)
mi_counties <- geojson_read('data/michigan_counties.geojson', what = 'sp')

# Reading in Covid-19 case data (https://github.com/nytimes/covid-19-data)
mi_covid <- read_csv('data/2020-04-12-Covid19_Counties.csv', col_types = cols())

# Tidying map df
tidy_mi_counties <- tidy(mi_counties, region = 'name')

# Tidying case df
tidy_mi_covid <- mi_covid %>%
  filter(state == 'Michigan') %>% # Only plotting MI data
  full_join(tibble(county = unique(tidy_mi_counties$id))) %>% # Adding in any missing MI county names using map df
  complete(date, county) %>% # Adding missing date/county combinations
  filter(!is.na(date)) %>% # Removing any rows without a date
  mutate(week = week(date)) %>% # Creating a week column to condense data
  group_by(week, county) %>% 
  summarize(cases = sum(cases, na.rm = TRUE)) %>% # Calculating total number of cases per county per week
  ungroup()

# Combining map and case dfs together
mi_data <- tidy_mi_counties %>% 
  left_join(tidy_mi_covid, by = c('id' = 'county')) # Combining dfs together for plotting



# Basic plot --------------------------------------------------------------

# Plotting the data from one week only
mi_data %>% 
  filter(week == 15) %>% 
  ggplot(aes(x = long, y = lat, group = group, fill = cases/1000)) + # Coloring by change in numnber of cases
  geom_polygon() + # Plotting the map
  coord_map() + # Changing viewport for visualization of map
  theme_void() # Removing all theme aesthetics

# Animating the plot
mi_plot_basic <- mi_data %>% 
  ggplot(aes(x = long, y = lat, group = group, fill = cases/1000)) + # Coloring by number of new cases
  geom_polygon() + # Plotting the map
  coord_map() + # Changing viewport for visualization of map
  theme_void() + # Removing all theme aesthetics
  labs(title = 'Week: {closest_state}') + # Adding dynamic title to note which data is being shown
  transition_states(week, transition_length = 1, state_length = 2) + # Setting animation to be 1 sec for transition and 2 sec to pause
  ease_aes('linear') # Making transition linear

# Setting gif timing, resolution, etc.
mi_plot_basic_gif <- animate(mi_plot_basic, duration = 18, fps = 10,
                             res = 150, width = 20, height = 20, unit = "cm")

# Saving the gif
anim_save(animation = mi_plot_basic_gif, filename = 'results/2020-04-13-mi_plot_basic.gif')



# Finished plot -----------------------------------------------------------

# Animating the total number of cases
mi_plot_finished <- mi_data %>% 
  ggplot(aes(x = long, y = lat, group = group, fill = cases/1000)) + # Coloring by number of cases
  geom_polygon(color = 'grey80', size = 0.1) + # Plotting the map
  coord_map() + # Changing viewport for visualization of map
  scale_fill_viridis(name="Total Covid-19 cases (k)", limits = c(0,50), breaks=c(0,10,20,30,40,50), na.value = 'grey80', # Changing the fill colors
                     guide = guide_legend(keyheight = unit(3, units = "mm"), # Making the color guide look pretty
                                          keywidth=unit(6, units = "mm"),
                                          label.position = "bottom", 
                                          title.position = 'top', 
                                          nrow=1)) +
  theme_void() + # Removing all theme aesthetics
  theme(legend.position = c(0.2, 0.26)) + # Moving legend position
  labs(title = 'Week: {closest_state}') + # Adding dynamic title to note which data is being shown
  transition_states(week, transition_length = 1, state_length = 2) + # Setting animation to be 1 sec for transition and 2 sec to pause
  ease_aes('linear') # Making transition linear

# Setting gif timing, resolution, etc.
mi_plot_finished_gif <- animate(mi_plot_finished, duration = 18, fps = 10,
                                      res = 150, width = 20, height = 20, unit = "cm")

# Saving the gifs
anim_save(animation = mi_plot_finished_gif, filename = 'results/2020-04-13-mi_plot_finished.gif')
