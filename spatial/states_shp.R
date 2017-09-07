# Making a land shapefile

#JA 12-30-2016

source('~/github/ohi-northeast/src/R/common.R')

#downloaded from US Census Bureau on 12-30-2016: https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html
states <- readOGR(dsn = file.path(dir_anx,'spatial/cb_2015_us_state_500k'),layer = 'cb_2015_us_state_500k')%>%
  crop(wgs_ext)

plot(states)

ne <- states[states$NAME %in% c("Massachusetts","New Hampshire","Rhode Island","Pennsylvania","Connecticut","New Jersey","New York","Maine","Vermont"),]

ne@data <- ne@data%>%
            dplyr::select(-STATEFP,-STATENS,-GEOID,-LSAD,-ALAND,-AWATER)

out <- spTransform(ne,us_alb)

writeOGR(out,dsn = 'spatial/shapefiles',layer = 'states',driver = 'ESRI Shapefile',overwrite_layer = T)
