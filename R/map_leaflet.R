# function to create a html leaflet map from the polygon footprints and light sources
# requires libraries leaflet, htmlwidgets

map_leaflet <- function(polygons_footprint, points_with_height, outname){
  map = leaflet() %>% addTiles() %>%   
    addPolygons(data = polygons_footprint, fill = FALSE, stroke = TRUE, color = 'red'
    ) %>%
    addMarkers(data = points_with_height,
               popup = paste('maximum light intensity:', points_with_height[['height']], '[DN]')
    ) %>%
    addLegend('bottomright', colors = 'red', labels = 'Light Coronal Area')
  wd <- getwd()
  saveWidget(map, paste0(wd, '/output/', outname))
}