setwd('spatial')
source('global.R')

library(leaflet)
library(htmlwidgets)


#create plotting colors
pal <- c("#A50026",  "#ABD9E9","#313695", "#E0F3F8","#D73027","#FEE090" ,"#F46D43",  "#FDAE61", "#74ADD1", "#4575B4")

## create map   
map <-  leaflet() %>% addProviderTiles(providers$CartoDB.Positron) %>%
      setView(lng = -70, lat = 42.5, zoom = 7) %>% 
    # Overlay groups
      addPolygons(data = ne_sa, fill = FALSE, weight = 0.8, group = "NE Ocean Plan Study Area", color = "black", dashArray = "3") %>%
      addPolygons(data = epu_offshore, fill = TRUE, weight = 0.5, group = "EPU offshore", color = c("#FA8072","#D73027","#FEE090" ,"#F46D43"), fillOpacity = 0.7) %>%
      addPolygons(data = state_wa, weight = 0.6, group = "State Waters", fillOpacity = 0.9, color = palette(blues9)) %>%
      addPolygons(data = epu, fill = TRUE, weight = 0.5, group = "Full EPUs", color = c("#FA8072","#D73027","#FEE090" ,"#F46D43"), fillOpacity = 0.7) %>%
      addPolygons(data = NH, weight = 0.5, fillOpacity = 0.9, group = "New Hampshire", color = blues9[5]) %>%
      addPolygons(data = ME, weight = 0.5, fillOpacity = 0.9, group = "Maine", color = blues9[6]) %>%
      addPolygons(data = RI, weight = 0.5, fillOpacity = 0.9, group = "Rhode Island", color = blues9[7]) %>%
      addPolygons(data = CT, weight = 0.5, fillOpacity = 0.9, group = "Connecticut", color = blues9[9]) %>%
      addPolygons(data = NY, weight = 0.5, fillOpacity = 0.9, group = "New York", color = blues9[8]) %>%
      addPolygons(data = MA, weight = 0.5, fillOpacity = 0.9, group = "Massachusetts", color = blues9[4]) %>%
      addPolygons(data = ca_eez, weight = 0.5, group = "Canadian EEZ", color = "darkred", fillOpacity = 0.4) %>%
      addPolygons(data = eez, weight = 0.5, group = "US EEZ", color = "lightred" , fillOpacity = 0.4) %>%
      addPolygons(data = n_cape, weight = 0.5, group = "N Cape Cod", color = "lightgreen", fillOpacity = 0.9) %>%
      addPolygons(data = s_cape, weight = 0.5, group = "S Cape Cod", color = "darkgreen", fillOpacity = 0.9) %>%
      # Layers control
      addLayersControl(
        overlayGroups = c("State Waters", "Maine","New Hampshire","Massachusetts","Rhode Island",
                          "Connecticut","New York","NE Ocean Plan Study Area","Full EPUs","EPU offshore","Canadian EEZ", "US EEZ", "N Cape Cod", "S Cape Cod"),
        options = layersControlOptions(collapsed = FALSE)) %>%
      hideGroup(c("Canadian EEZ", "US EEZ", "Full EPUs", "EPU offshore", "New Hampshire","Maine","Rhode Island",
                  "Connecticut","New York","Massachusetts","N Cape Cod", "S Cape Cod"))
      
## save map as html widget  
setwd('spatial')
saveWidget(map, file="interactive_rgns_map.html")
