# script to save northeast coastal counties as a shapefile for use in maps
setwd('spatial')
library(raster)
library(sf)
us<-getData('GADM', country='USA', level=2)  #Get the County Shapefile for the US
plot(us)

#filter for the counties in our region. Some duplicates so we need to manually get those out (e.g. Essex is in upstate NY and coastal MA)
ne <- st_as_sf(us) %>%
        filter(NAME_1 %in% c("Maine", "New Hampshire", "Massachusetts", "Connecticut", "New York", "Rhode Island")) %>%
        filter(NAME_2 %in% c("Fairfield", "Middlesex", "New Haven", "New London","Nassau", "Cumberland", "Hancock", "Knox", "Lincoln", "Sagadahoc", "Waldo", "Washington", "York", "Barnstable", "Bristol", "Dukes", "Essex", "Nantucket", "Norfolk", "Plymouth", "Suffolk",
                              "Rockingham", "Westchester", "Strafford", "Kent", "Newport", "Providence", "Queens", "Kings", "Bronx")) %>%
        filter(!OBJECTID %in% c(1846, 1889))  #object ids for essex in NY, Washington in NY
  
plot(ne[1])

#save 

st_write(ne, dsn = '.', layer = 'ne_counties.shp', driver = "ESRI Shapefile")
