# Script contains helper function to avoid repeatedly copy-pasting code across rmd's
#____________________________________________________________________________________

# load packages
library(tidyverse)
library(kableExtra) #allows for table customisation 

# this creates a new function that filters the top 5 songs of the input decade 
create_top_5 <- function(decade_input) {
  spotify_data_clean %>% 
    filter(decade == decade_input,
           decade_rank < 6) %>%
    select(decade_rank:year) %>% 
    kable(col.names = c("Decade Rank", #renames column headers 
          "Title",
          "Artist",
          "Genre",
          "Year")) %>% #creates a table
    kable_styling() %>% #allows customisation of the table 
    column_spec(column = 1:5, color = 'white', background = 'black') %>% #customises column colour 
    row_spec(row = 0, background = 'black', bold = TRUE) #customises header row
  
}

# this creates a new function that counts the top 10 genres of the input decade 
create_top_genre <- function(decade_input) {
  genre_data <- spotify_data_clean %>% 
    filter(decade == decade_input) %>% 
    count(top_genre, sort=TRUE) %>% #this counts how many occurences there are of the same genre 
    head(10) #lists the top 10 cases only 
 
  # create the ggplot within the custom function 
   genre_data %>%
    mutate(top_genre = reorder(top_genre, -n)) %>% #reorder before making ggplot so the legend and column colours line up
    ggplot(aes(
        x = top_genre,
        y = n, 
        fill = top_genre
      )) + 
    geom_col() +
    geom_text(aes(label=n), vjust=-0.3, size=3.5) +
    ggtitle(
      paste0("Top Genres of the ", decade_input,"'s")) + #paste0 mashes strings (e.g. text) together - this lets me automatically input the decade for each page. 
    xlab("Genre") +                  
    ylab("Number of Top 100 Songs in Genre") +
    scale_fill_discrete(name = "Genre") +
    scale_y_continuous(expand = c(0, 0), limits = c(0, NA)) +
    theme_classic() +
    theme(
      axis.text.x = element_blank(), #removes variable names on x-axis 
      axis.ticks.x = element_blank(),  #removes ticks on x-axis 
      plot.title = element_text(size = 16, 
                                face = "bold", 
                                hjust = 0.5), #centers the plot title 
    )
  
}

# creates a new function that runs a stepwise regression to infer popularity for the input decade 
stepwise_popular_model <- function(decade_input) {
  regression <- step(
    lm(popularity ~ bpm + #lm means 'linear model' 
            energy +
            danceability +
            loudness +
            liveness +
            valence +
            duration +
            acousticness +
            speechiness,
          data = spotify_data_clean %>% 
            filter(decade == decade_input)), #only want to do a regression one decade at a time 
    direction="both", #makes it a stepwise regression, rather than a forwards or backwards only one 
    trace = FALSE) #removes the output that gets printed at each step of the regression (there is way too much because there's so many steps)
  
  # select what part of hidden output to show - I'm only interested in the final regression coefficients 
  summary(regression)
}
