#common.R

#This script has common paths, libraries for the OHINE project


# set the neptune data_edit share based on operating system
dir_M             <- c('Windows' = '//mazu.nceas.ucsb.edu/ohi',
                       'Darwin'  = '/Volumes/ohi',    ### connect (cmd-K) to smb://mazu/ohi
                       'Linux'   = '/home/shares/ohi')[[ Sys.info()[['sysname']] ]]

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

rm(packages)

#spatial information

## extent for region of interest
ne_ext <- raster::extent(1719007,2564139,298989,1199438) #this is for us_albers projection only
par(mar = c(1,1,1,1))

### set up proj4string options: NAD1983 and WGS84
p4s_wgs84 <- '+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0'
p4s_nad83 <- '+proj=longlat +ellps=GRS80 +datum=NAD83 +no_defs +towgs84=0,0,0'
us_alb    <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs" 


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
