### Team: Kraftfahrzeug-Haftpflichtversicherung
### Authors: Felten, Bettina; Stuhler, Sophie C.
### Date: 02-02-2017
### Project Assignment
### identify oil/gas drilling rigs in the north sea by their light emmission due to oil/gas burning, quantify the emission
### quantification is done by intensity, the best available nightlight image was a composite over 22 days in 2012
### nightlight image intensity is rescaled to 8 bit, therefore maximum intensity of fires is 255
### for further use, if nightlight data in radiance available, use those to quantify the actual emitted radiation

# Install package ForestTools
install.packages('ForestTools')   # xorg-dev required


# Import libraries
library(sp)
library(rgdal)
library(rgeos)
library(raster)
library(viridisLite)   # creation of color palette
library(ForestTools)   # requires R 3.3.x
library(leaflet)
library(htmlwidgets)


# Load functions
source('R/getsourcedata.R')
source('R/checkdir.R')
source('R/reproject.R')
source('R/preprocess_nightlights.R')   # includes a bash command for Linux, might be time consuming
source('R/find_emission_sources.R')
source('R/map_leaflet.R')
source('R/plot_nightlights.R')



# check if required folders are present
checkdir('data')
checkdir('output')

# Preprocess nightlights
nlcoastcleared <- preprocess_nightlights()
pairs(nlcoastcleared)

# First band (visnir) shows highest contrast (shorter wavelength results in lower background emmission, see Planck law)
nightlights_visnir <- nlcoastcleared[['nightlightscoastcleared.1']]

# Find emission sources (Drilling Rigs = sources; Light Circles = light_objectsPoly)
lights <- find_emission_sources(nightlights_visnir, lowpass = TRUE)
light_sources <- lights[[1]]
light_objectsPoly <- lights[[2]]

# create html map of light circles and light sources, markers with maximum brightness
map_leaflet(light_objectsPoly, light_sources, 'individual_lights.html')

# Plot nightlights and emission polygons
northseafile <- list.files('data/northsea', pattern = glob2rx('*.shp'), full.names = T)
northsea <- readOGR(northseafile, layer = 'iho')
plot_northsealights(nightlights_visnir, northsea)
plot_northseaobjects(nightlights_visnir, light_objectsPoly, northsea)

