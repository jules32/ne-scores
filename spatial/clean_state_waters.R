#This script cleans the state waters shapefile that was edited in QGIS to remove rivers in Maine. After cleaning in QGIS,
#orphan holes remained so the cleangeo package here takes care of the orphan holes.

install.packages('cleangeo')
library(cleangeo)

source('~/github/ohi-northeast/common.r')

#state waters with some Maine rivers removed (done in QGIS)
state_wa <- readOGR(dsn = file.path(dir_anx,'spatial'), layer = 'StateWaters_wo_rivs', verbose = FALSE)%>%
  spTransform(p4s_nad83)
#remove vermont
state_wa <- state_wa %>% subset(!NAME10=="Vermont")

#get a report of geometry validity & issues for a sp spatial object
report <- clgeo_CollectionReport(state_wa)
summary <- clgeo_SummaryReport(state_wa)
issues <- report[report$valid == FALSE,]

#get suspicious features (indexes)
nv <- clgeo_SuspiciousFeatures(report)

#try to clean data
mysp.clean <- clgeo_Clean(state_wa)

#check if they are still errors
report.clean <- clgeo_CollectionReport(mysp.clean)
clgeo_SummaryReport(report.clean)

writeOGR(mysp.clean,dsn = file.path(dir_anx,'spatial'),layer = 'StateWaters_wo_rivs_cleaned',driver = 'ESRI Shapefile')
