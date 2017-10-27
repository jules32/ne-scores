#common.R

#This script has common paths, libraries for the OHINE project


# set the mazu data_edit share based on operating system
dir_M             <- c('Windows' = '//mazu.nceas.ucsb.edu/ohi',
                       'Darwin'  = '/Volumes/ohi',    ### connect (cmd-K) to smb://mazu/ohi
                       'Linux'   = '/home/shares/ohi')[[ Sys.info()[['sysname']] ]]
#set additional paths
dir_git <- '~/github/ohi-northeast'
dir_rgn <- file.path(dir_git, 'prep/regions')  ### github: general buffer region shapefiles
dir_anx <- file.path(dir_M, 'git-annex/neprep')
dir_calc <- file.path(dir_git, 'region2016') #where the calculations happen

# WARN rather than stop if directory doesn't exist
if (!file.exists(sprintf('%s/',dir_M))){
  warning(sprintf("The directory for variable dir_M set in src/R/common.R does not exist. Do you need to mount %s?", dir_M))
  
}

# install (if necessary) and load commonly used libraries
packages <- c('tidyverse','dplyr', 'tidyr', 'stringr', 'readr', 'ggplot2')
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  cat(sprintf("Installing %s\n", setdiff(packages, rownames(installed.packages()))))
  install.packages(setdiff(packages, rownames(installed.packages())))
}

#round everything to 2 decimal places
options(digits=2, scipen = 999)

#libraries
library(tidyverse)
library(stringr)
library(RColorBrewer)
library(foreach)
library(doParallel)
library(rgdal)
library(parallel)
library(raster)

rm(packages)

select <- dplyr::select

#spatial information

## extent for region of interest
wgs_ext <- raster::extent(-85, -55,30, 50) # this is larger than the actual NE extent. Only use this when cropping, then reprojecting to albers, and then crop again using the ne_ext
ne_ext <- raster::extent(1750000, 2550000,300000,1200000) #this is for us_albers projection only
moll_ext <- raster::extent(-6511398, -5150310, 4406529, 5490090) ##JA DO THIS

### set up proj4string options: NAD1983 and WGS84
p4s_wgs84 <- '+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0'
p4s_nad83 <- '+proj=longlat +ellps=GRS80 +datum=NAD83 +no_defs +towgs84=0,0,0'
us_alb    <- raster::crs("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs") 

### useful shapefiles
#state land boundaries
ne_states  <- sf::st_read(dsn = paste0(path.expand(dir_git),'/spatial/shapefiles'),layer = 'states')
rgns       <- sf::st_read(dsn = paste0(path.expand(dir_git),'/spatial/shapefiles'),layer = 'ne_ohi_rgns') #need to use path.expand because readOGR does not read '~'
rgns_simp  <- sf::st_read(dsn = paste0(path.expand(dir_git),'/spatial/shapefiles'),layer = 'ne_ohi_rgns_simp') #need to use path.expand because readOGR does not read '~'
rgn_data   <- data.frame(rgns) %>% 
  select(-geometry) %>% 
  mutate(rgn_name = as.character(rgn_name),
         state = ifelse(str_detect(rgn_name, "Massachusetts"), "Massachusetts", rgn_name))
ocean_ne   <- raster::raster('~/github/ohi-northeast/spatial/ocean_rasters/ocean_ne.tif')
ocean_rgns <- raster::raster('~/github/ohi-northeast/spatial/ocean_rasters/ocean_rgns.tif')
zones      <- ocean_rgns #for zonal stats
three_nm <- rgns %>% filter(rgn_id < 8)   #use the state water boundaries as the 3 nautical mile shapefile

### Define spectral color scheme for plotting maps
cols      = rev(colorRampPalette(brewer.pal(9, 'Spectral'))(255)) # rainbow color scheme

### generic theme for all plots
ggtheme_basic <- theme(axis.ticks = element_blank(),
                       text = element_text(family = 'Helvetica', color = 'gray30', size = 12),
                       plot.title = element_text(size = rel(1.25), hjust = 0, face = 'bold'),
                       legend.position = 'right')


ggtheme_plot <- ggtheme_basic +
  theme(panel.border     = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_line(colour = 'grey90'),
        panel.background = element_blank(),
        axis.line = element_line(colour = "grey30"))

### Source function that outputs a tmap score map

source('~/github/ohi-northeast/src/R/plot_scores.R')
