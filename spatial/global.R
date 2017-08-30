library(sf)
library(tidyverse)
library(rgdal)


# set the mazu data_edit share based on operating system
dir_M             <- c('Windows' = '//mazu.nceas.ucsb.edu/ohi',
                       'Darwin'  = '/Volumes/ohi',    ### connect (cmd-K) to smb://mazu/ohi
                       'Linux'   = '/home/shares/ohi')[[ Sys.info()[['sysname']] ]]
#set additional paths
dir_git <- '~/github/ohi-northeast'
dir_rgn <- file.path(dir_git, 'prep/regions')  ### github: general buffer region shapefiles
dir_anx <- file.path(dir_M, 'git-annex/neprep')


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
ne_states  <- readOGR(dsn = paste0(path.expand(dir_git),'/spatial'),layer = 'states',verbose=F)


#full northeast region
ne_sa <- st_read(dsn = ".", layer = "ne_region_plus_states", quiet = T)

## states
states <- st_read(dsn = '~/github/ohi-northeast/spatial', layer = 'states', quiet=T) %>%
  st_transform(p4s_nad83)

states <- st_intersection(states, st_set_crs(st_as_sf(as(raster::extent(-75,-65,39.5,45), "SpatialPolygons")), st_crs(states)))

## state waters with some Maine rivers removed (done in QGIS)
state_wa <- st_read(dsn = file.path(dir_anx,'spatial'), layer = 'StateWaters_wo_rivs_cleaned',quiet=T) %>%
  st_transform(p4s_nad83)

## canada EEZ

ca_eez <- st_read(dsn = "~/github/ohi-northeast/spatial", layer = "ca_eez_crop", quiet = T)

## EPUs
epu <- st_read(dsn = ".", 'epu_extended',quiet=T)

epu_offshore <- st_read(dsn = "~/github/ohi-northeast/spatial", layer = "epu_extended_offshore", quiet = T)

## US EEZ

eez <- st_read(dsn = '~/github/ohi-northeast/spatial',layer = 'ne_eez',quiet=T)%>%
  st_transform(crs = p4s_nad83)

## Define each region

ME = state_wa %>%
  filter(NAME10 == "Maine")

NH = state_wa %>%
  filter(NAME10 == "New Hampshire")

RI = state_wa %>%
  filter(NAME10 == "Rhode Island")

MA = state_wa %>%
  filter(NAME10 == "Massachusetts")

CT = state_wa %>%
  filter(NAME10 == "Connecticut")

NY = state_wa %>%
  filter(NAME10 == "New York")

## South of Cape Cod

s_cape <- st_read(dsn = ".", layer = "s_cape_cod")

## North of Cape Cod

n_cape <- st_read(dsn = ".", layer = "n_cape_cod")