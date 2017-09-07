## Spatial data for OHI Northeast

`clean_state_waters.R` cleans the state waters shapefile that was edited in QGIS to remove rivers in Maine. After cleaning in QGIS, orphan holes remained so the cleangeo package here takes care of the orphan holes.

`ma_counties.R` assigns Massachussetts counties to OHI regions. Since MA splits between two biogeographical regions, and a lot of our data will be at the county level, we will have to manually assign the counties to each region. What makes this complicated is that a couple counties are found in both.

`master_rasters.R` creates base rasters for use in the OHI-Northeast data prep.

`ne_coastal_counties.R` script to save northeast coastal counties as a shapefile for use in maps

`ne_regions.Rmd`

`ne_rgn_options.Rmd` provides different options for configuring the final set of regions

`ne_rgn_options_sep_wkshp.Rmd` creats all maps used for the September 21 workshop

`simplify_rgns.R` simplifies the OHI NE Regions shapefile for faster plotting

`states_shp.R` makes a shapefile for state borders (on land)

`wkshp_interactive_map.R` creates an html widget to turn polygons on and off

`global.R` is sourced by `wkshp_interactive_map.R` and loads all shapefiles for plotting in the interactive map.

`ocean_rasters` contain two rasters with cell resolution of 1km^2^. 

`shapefiles` is a folder where all shapefiles are kept

