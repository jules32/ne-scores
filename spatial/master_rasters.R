#creating master rasters

# This script creates base rasters for use in the OHI-Northeast data prep.
#------------------------------------------------------------------------

#
source('~/github/ohi-northeast/src/R/rast_tools.R')

library(dplyr)
library(raster)
library(rgdal)

## extent for region of interest
wgs_ext <- raster::extent(-85, -55,30, 50) # this is larger than the actual NE extent. Only use this when cropping, then reprojecting to albers, and then crop again using the ne_ext
ne_ext  <- extent(1750000, 2550000,300000,1200000) #this is for us_albers projection only

### define US albers coordinate reference system (CRS)
us_alb    <- crs("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs") 
#---------------------------------------------------------------------------------

#create a base raster with 1000x1000, crs = us_alb and ne extent
r <- raster(crs = us_alb, ne_ext, res = 1000)
r[r]<-1
plot(r)
plot(rgns,add=T)

#remove land so we just have an ocean raster
land  <- readOGR(dsn = file.path(dir_M,'git-annex/globalprep/spatial/d2014/data'),layer = 'regions_gcs')%>%
            subset(rgn_nam == 'United States' | rgn_nam == 'Canada')%>%
            subset(rgn_typ == 'land')%>%
            crop(wgs_ext)%>%
            spTransform(us_alb)%>%
            crop(ne_ext)

plot(r)
plot(land,add=T)

#remove cells that overlap land by using inverse=T
ocean_ras <- mask(r,land,inverse=T)
plot(ocean_ras)
plot(rgns,add=T)

#save to spatial file. This is for all ocean areas in the NE region, not only our regions
writeRaster(ocean_ras,filename = 'ocean_rasters/ocean_ne.tif',overwrite=T)
#-------------------------------------------------------------------------

#create an ocean raster at 1km res with only the rgns, the cell values = rgn_id
  
#the function gdal_rast2 comes from rast_tools.R
rgn_ras <- gdal_rast2(src = '~/github/ohi-northeast/spatial/ne_ohi_rgns',
                      rast_base = ocean_ras,
                      dst = 'ocean_rasters/ocean_rgns.tif',
                      value = 'rgn_id',
                      override_p4s = TRUE)

