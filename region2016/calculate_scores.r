## calculate_scores.R

## This script calculates OHI scores with the `ohicore` package.
## - configure_toolbox.r ensures your files are properly configured for `ohicore`.
## - The `ohicore` function CalculateAll() calculates OHI scores.

## set working directory for all OHI calculations ----
setwd("~/github/ne-scores/region2016")

## load required packages. If not installed, install from the comment ----
library(ohicore)   # source('~/github/ohi-northeast/install_ohicore.R')
library(tidyverse) # install.packages('tidyverse')
library(stringr)   # install.packages('stringr')
library(zoo)       # install.packages('zoo')


## calculate scores for each year scenario and save to a single csv file ----

## set scenario years, empty dataframe
scenario_years <- c(2012:2015)
scores_all_years <- data.frame()

## loop through each scenario year
for (s_year in scenario_years){  # s_year=2015
 
  message(sprintf('--- Calculating Scores for scenario year %s ----', s_year))
  
  ## configure checks
  conf   <-  ohicore::Conf('conf')
  layers <-  ohicore::Layers(layers.csv = 'layers.csv', layers.dir = 'layers')
  layers$data$scenario_year <-  s_year 
  
  ## calculate scores
  scores_sy <- ohicore::CalculateAll(conf, layers) %>%
    mutate(year = s_year) 
  
  ## bind scores to dataframe
  scores_all_years <- rbind(scores_all_years, scores_sy)
  
}

## save .csv file
readr::write_csv(scores_all_years, 'scores.csv', na='')
