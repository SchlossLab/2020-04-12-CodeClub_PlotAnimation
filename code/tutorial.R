# NOTE: Solutions are available at the bottom of the script

# Loading dependencies ----------------------------------------------------

# Loading libraries
library(tidyverse)
library(gapminder)



# Part 1 - Complex relationships ------------------------------------------

### Exercises
# 1) Using economics dataset, show relationship between number of people unemployed and the duration of unemployment over time
?economics


# 2) Using gapminder dataset, show relationship between population and GDP per capita over time
?gapminder










# Part 2 - Animation ------------------------------------------------------

### Demonstration
# Without animation
economics %>%
  ggplot(aes(x = date, y = unemploy, size = uempmed)) +
  geom_point()

# With animation
economics %>%
  ggplot(aes(x = date, y = unemploy, size = uempmed)) +
  geom_point() +
  labs(title = 'Date: {frame_time}') + # Adds time variable to title
  transition_time(date) + # Variable being used to cycle time
  shadow_mark() # Shows previous points

### Exercises
# 1) Using animation, show relationship between number of people unemployed and the duration of unemployment over time


# 2) Using animation, show relationship between population and GDP per capita over time










# Part 3 - Saving ---------------------------------------------------------

### Demonstration
# Making the plot look nicer (TIP: plot a single frame to optimize aesthetics without needing to render completely)
gapminder %>% 
  filter(year == 1952) %>% 
  ggplot(aes(x = log10(pop), y = lifeExp, size = gdpPercap, color = country)) +
  geom_point(show.legend = FALSE) +
  scale_colour_manual(values = country_colors) + # Coloring by country using color dictionary
  scale_size(range = c(2, 12)) +
  facet_wrap(~ continent)

# Save the plot to a variable (no need to look at it yet)
gapminder_plot <- gapminder %>% 
  ggplot(aes(x = log10(pop), y = lifeExp, size = gdpPercap, color = country)) +
  geom_point(show.legend = FALSE) +
  scale_colour_manual(values = country_colors) + # Coloring by country using color dictionary
  scale_size(range = c(2, 12)) +
  facet_wrap(~ continent) +
  labs(title = 'Year: {frame_time}') +
  transition_time(year)

# Setting characteristics for the saved gif
# Low frames per second
gapminder_plot_gif <- animate(gapminder_plot, duration = 10, fps = 1,
                              res = 150, width = 20, height = 20, unit = "cm")

# Better frames per second
gapminder_plot_gif <- animate(gapminder_plot, duration = 10, fps = 10,
                              res = 150, width = 20, height = 20, unit = "cm")

# Saving the gif (TIP: View saved gifs using your web browswer)
anim_save(animation = gapminder_plot_gif, filename = 'results/gapminder.gif')


### Exercises
# 1) Save one of your animated plots from before as a gif



































# Solutions ---------------------------------------------------------------

### Part 1
# 1) Using economics dataset, show relationship between number of people unemployed and the duration of unemployment over time
?economics
economics %>%
  ggplot(aes(x = date, y = unemploy, size = uempmed)) +
  geom_point()


# 2) Using gapminder dataset, show relationship between population and GDP per capita over time
?gapminder
gapminder %>%
  ggplot(aes(x = year, y = lifeExp, color = log10(pop))) +
  geom_point()



### Part 2
# 1) Using animation, show relationship between number of people unemployed and the duration of unemployment over time
economics %>%
  ggplot(aes(x = uempmed, y = unemploy)) +
  geom_point() +
  labs(title = 'Date: {frame_time}') +
  transition_time(date)

# 2) Using animation, show relationship between population and GDP per capita over time
gapminder %>%
  ggplot(aes(x = log10(pop), y = lifeExp)) +
  geom_point(show.legend = FALSE) +
  labs(title = 'Year: {frame_time}') +
  transition_time(year)



### Part 3
# 1) Save one of your animated plots from before as a gif
economics_plot <- economics %>%
  ggplot(aes(x = uempmed, y = unemploy)) +
  geom_point() +
  labs(title = 'Date: {frame_time}') +
  transition_time(date)

# Better frames per second
economics_plot_gif <- animate(economics_plot, duration = 10, fps = 10,
                              res = 150, width = 20, height = 20, unit = "cm")

# Saving the gif
anim_save(animation = economics_plot_gif, filename = 'results/economics.gif')
