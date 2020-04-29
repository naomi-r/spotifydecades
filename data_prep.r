# Script for organising data 
# Note:In data frames, year refers to re-release date rather than original release date
# This mainly affects older decades e.g. the release date is listed as 2001 instead of 1951
#________________________________________________

# load packages 
library(tidyverse)

# create vector of data years to loop over (note file names are 1950.csv, 1960.csv etc.)
data_years <- seq(1950, 2010, 10)  

# create empty tibble to put data of decades combined into 
spotify_data_full <- tibble()

# create loop that reads csv's and mutates a 'decade' variable, indicating which csv the row came from
# this creates a long table to easily compare between decades 
# use absolute path for csv's so this file can find the csv's when sourced from rmd's
for (decade_name in data_years) { #e.g. set decade name to 1950, then run it all...set decade name to 1960, run it all etc. 
  decade_data_frame <- read_csv(paste0("/cloud/project/", decade_name, ".csv"))  #paste0 mashes strings (e.g. text) together - this lets me automatically input the next decade in the file name for each loop
  decade_data_frame <- decade_data_frame %>% 
    mutate(decade = decade_name)
  
# bind all the csv's together into the empty tibble, one at a time for each loop 
  spotify_data_full <- spotify_data_full %>% 
    bind_rows(decade_data_frame) 
}

# check which columns contain missing values (contain N/A)
colSums(is.na(spotify_data_full))
# when viewing in console, genre is only variable containing N/A (16 cases)

# clean the data 
spotify_data_clean <- spotify_data_full %>% 
  rename (decade_rank = Number,    #year of song release (re-release song date overrides original song date (mainly for 1950's))
          top_genre = `top genre`, #genre of the song
          energy = nrgy,           #energy of a song, the higher the value the more energetic the song is
          danceability = dnce,     #the higher the value, the easier it is to dance to this song
          loudness = dB,           #the higher the value, the louder the song (in decibels)
          liveness = live,         #the higher the value, the more likely the song is a live recording
          valence = val,           #the higher the value, the more positive mood for the song
          duration = dur,          #the duration of the song (in seconds)
          acousticness = acous,    #the higher the value the more acoustic the song is
          speechiness = spch,      #the higher the value the more spoken word the song contains
          popularity = pop) %>%    #the higher the value the more popular the song is
  mutate(top_genre = replace_na(top_genre, "unspecified")) 
  









