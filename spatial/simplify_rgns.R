## Simplifying the OHI NE Regions shapefile for faster plotting

library(rgdal)
library(rgeos)

rgns       <- readOGR(dsn = paste0(path.expand(dir_git),'/spatial'),layer = 'ne_ohi_rgns', verbose = FALSE) #need to use path.expand because readOGR does not read '~'

#gSimplify

rgns_simp <- gSimplify(rgns, tol = 100, topologyPreserve = TRUE)
rgns_simp <- SpatialPolygonsDataFrame(rgns_simp,data=as.data.frame(rgns@data))
writeOGR(rgns_simp,dsn = 'spatial/shapefiles',layer = 'ne_ohi_rgns_simp',driver="ESRI Shapefile")

# Removing small polygons