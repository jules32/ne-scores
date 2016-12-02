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
library(raster)
library(rgdal)
library(parallel)

rm(packages)

#spatial information

## extent for region of interest
wgs_ext <- raster::extent(-85, -55,30, 50) # this is larger than the actual NE extent. Only use this when cropping, then reprojecting to albers, and then crop again using the ne_ext
ne_ext  <- raster::extent(1719007,2564139,298989,1199438) #this is for us_albers projection only
par(mar = c(2,2,1,1))

### set up proj4string options: NAD1983 and WGS84
p4s_wgs84 <- '+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0'
p4s_nad83 <- '+proj=longlat +ellps=GRS80 +datum=NAD83 +no_defs +towgs84=0,0,0'
us_alb    <- crs("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs") 

### useful shapefiles
#state land boundaries
ne_states <- readOGR(dsn = file.path(dir_anx,'spatial'),layer = 'states', verbose = FALSE)%>%subset(STATE_NAME %in% c('Maine','New Hampshire','Massachusetts','Vermont','Connecticut','New York','Rhode Island', 'New Jersey','Delaware','Pennsylvania'))%>%
              spTransform(us_alb)

rgns <- readOGR(dsn = file.path(dir_git,'spatial'),layer = 'ne_ohi_rgns', verbose = FALSE)

### create an ocean only raster for the region

ocean_glob <- raster(file.path(dir_M,'model/GL-NCEAS-Halpern2008/tmp/ocean.tif'))
# ocean_ne   <- ocean_glob%>%
#               crop(extent(-7208377,-4464697,2652234,6643042))%>% #crop to smaller region to speed up process
#               projectRaster(crs = us_alb,progress='text', res = 1000)%>%
#                 crop(ne_ext, filename = '~/github/ohi-northeast/spatial/ocean_rasters/ocean_ne.tif')
# ocean_rgns <- mask(ocean_ne,rgns,filename = '~/github/ohi-northeast/spatial/ocean_rasters/ocean_rgns.tif')

ocean_ne   <- raster('~/github/ohi-northeast/spatial/ocean_rasters/ocean_ne.tif')
ocean_rgns <- raster('~/github/ohi-northeast/spatial/ocean_rasters/ocean_rgns.tif')

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
