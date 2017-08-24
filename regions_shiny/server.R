
source('global.R')

library(shiny)
library(leaflet)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  rgns <- eventReactive(input$regions)
  
  output$mymap <- renderLeaflet({
    
    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addPolygons(data = rgns())
    
  })
  
})
