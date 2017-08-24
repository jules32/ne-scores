library(sf)
library(tidyverse)

source('~/github/ohi-northeast/src/R/common.R')

## ne planning region
ne_roi <- st_read(dsn = file.path(dir_anx, 'spatial'), layer = 'ne_plan_poly', quiet = T) %>%
  st_transform(p4s_nad83) %>%
  mutate(region = "NE Planning Region")

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

epu <- st_read(dsn = "~/github/ohi-northeast/spatial", layer = "epu_extended", quiet = T)

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









  