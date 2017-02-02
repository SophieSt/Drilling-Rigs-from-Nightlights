## function that searches for emission sources, aka tree tops, segments input image and creates polygons (also saves)
## for composite images, a lowpass filtering can be applied, set lowpass to TRUE then
## the hereby used functions were taken from the package ForestTools which extracts tree crowns from a Canopy Height Model (CHM)
## the nightlight image acts similarly as a CHM and light sources can be compared to tree tops
## requires libraries raster, ForestTools, rgdal

find_emission_sources <- function(nightlight_image, min_height = 100, lowpass = FALSE, winSizeLowpass = 5){
  if (lowpass == TRUE) {
    # create the filter marix from the window size
    win_matrix <- matrix(1/(winSizeLowpass^2), nc = winSizeLowpass, nr = winSizeLowpass)
    # low-pass-filtering of input image, to smooth emission 'bulbs', that have unperfect shapes with more than one maximum per emission source
    nightlights_chm <- focal(nightlight_image, w = win_matrix)
  } else {
    # when no filtering is needed/applied, just use input image CHM/brightness image
    nightlights_chm <- nightlight_image
  }
  
  # function to determine the window size/radius for searching for 'tree tops'/light sources, given as function from height/brightness
  # use minimum height/brightness for emission sources, default is 100 DN
  lin <- function(x){0.0001 * x}
  light_sources <- TreeTopFinder(CHM = nightlights_chm, winFun = lin, minHeight = min_height, maxWinDiameter = NULL, verbose = T)
  # save light sources
  writeOGR(light_sources, 'output/light_sources.kml', 'light_sources', 'KML', overwrite_layer = T)
  # perform a segmentation coming from the tree tops/light sources to obtain inividual light objects
  light_objects <- SegmentCrowns(treetops = light_sources, CHM = nightlights_chm, minHeight = min_height)
  # transform them into polygons and save
  light_objectsPoly <- rasterToPolygons(light_objects, dissolve = TRUE)
  writeOGR(light_objectsPoly, 'output/light_objectsPoly.kml', 'light_objectsPoly', 'KML', overwrite_layer = T)
  
  return (c(light_sources, light_objectsPoly))
}
