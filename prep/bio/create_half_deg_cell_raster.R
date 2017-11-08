## Create regional half-degree cell raster

## This script creates a raster of half-degree cells used by AquaMaps to map species ranges specifically for the Northeast region.

library(raster)
source('~/github/ohi-northeast/src/R/common.R')

## read in raster from mazu
global_cells <- raster(file.path(dir_M, 'git-annex/globalprep/spp_ico/rgns/loiczid_raster.tif'))
plot(global_cells)

## mask using the NE rgns transformed into wgs84 to match raster CRS

rgns_wgs <- rgns%>%
  spTransform(p4s_wgs84)

ne_cells <- crop(global_cells, rgns_wgs);plot(ne_cells); plot(rgns_wgs, add=T)

## save as "loiczid.tif"

writeRaster(ne_cells, file = "~/github/ohi-northeast/prep/bio/data/loiczid.tif")
