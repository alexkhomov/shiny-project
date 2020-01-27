library(shinydashboard)
library(shiny)
library(tidyverse)
library(ggplot2)
library(googleVis)
library(readr)
library(DT)

#### READ THE DATA ####

Netflix_Subscribers <- read_csv("Netflix_Subscribers.csv")

netflix = read.csv('netflix_titles.csv', stringsAsFactors = F)

netflix$description = NULL
netflix$show_id = NULL


netflix = netflix %>% 
  separate(date_added, sep = ', ', into = c('month', 'added_year')) %>% 
  mutate(month = str_trim(month)) %>% 
  separate(month, into = c('month','day'))

netflix$day = NULL


netflix$added_year = round(as.integer(netflix$added_year))
netflix$release_year = round(as.integer(netflix$release_year))


netflix = left_join(netflix, Netflix_Subscribers,by = c('added_year' = 'year', 'month'))


#fill in NAs in the 'added_year' column by making them equal to the movie releas year

netflix$added_year = ifelse(is.na(netflix$added_year) == TRUE, netflix$release_year, netflix$added_year)


#Gather everything that is prior to 2015 into 2015
#and change 2020 to 2019 since data is from the end of 2019

for (i in 1:nrow(netflix)) {
  if (netflix$added_year[i] <= 2015) {
    netflix$added_year[i] = 2015
  } else if (netflix$added_year[i] == 2020) {
    netflix$added_year[i] = 2019
  }
}


#fill in the blanks in the month column, by the value of preceding column

for (i in 1:nrow(netflix)) {
  if (netflix$month[i] == '') {
    netflix$month[i] = netflix$month[i-1]
  }
}

## Replace Ratings with Groups ##

netflix %>% 
  mutate(rating = ifelse(rating %in% c('TV-MA','R','NC-17'), 'adults',
                  ifelse(rating %in% c('TV-14','TV-PG', 'PG-13', 'PG'), 'teenagers',
                  ifelse(rating %in% c('TV-Y7', 'TV-G','TV-Y', 'TV-Y7-FV', 'G'),'children', 'unrated')))) -> netflix




## Split Duration Column in minutes and seasons ##

netflix = netflix %>% 
  separate(duration, sep = ' ', into = c('duration', 'units'))

## Data only for the movies made at least partially in United States

netflix %>% 
  filter(str_detect(country, 'United States')) -> netflixUS
