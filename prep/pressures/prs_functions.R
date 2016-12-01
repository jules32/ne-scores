# Functions to crop global pressures to your region

cropPressure <- function(file, rgn_crs, rgn_ext, filename){

          ### check libraries: raster, rgdal
          pkgs <- c('raster', 'rgdal')
          for (pkg in pkgs[!paste('package:', pkgs, sep = '') %in% search()]) {
            message('loading package: ', pkg)
            library(pkg, character.only = TRUE)
          }
          
          if(!is.raster(x)){
            file = raster(x)
          }else{
            file = x
          }
          
          #crs of global pressure file
          prs_crs <- crs(file)
          
          if(prs_crs@projargs == "+proj=longlat +ellps=WGS84 +no_defs"){
            c_file <- crop(file,wgs_ext)
            
          }else{
            c_file <- file
          }
          
          ##Check crs to see if they match, if not, throw error that CRS needs to be set
          if(!is.na(rgn_crs) & !is.na(prs_crs)) {
            ### neither CRS is NA
            if(rgn_crs@projargs != prs_crs@projargs) {
              message('Reprojecting pressure raster to region CRS: ', rgn_crs@projargs)
              prs_rast <- raster::projectRaster(c_file, crs = rgn_crs, progress='text')
            } else {
              message('Pressure raster and region polygons in same CRS: no reprojection')
              prs_rast <- c_file ### no need to reproject
            }
          } else {
            message('Missing coordinate reference system for pressure raster or region polygon.')
            return(NULL)
          }
          
          ###Crop to rgn extent
          c = crop(prs_rast,rgn_ext, filename = filename,overwrite=T)
          
          return(c)
   
}
