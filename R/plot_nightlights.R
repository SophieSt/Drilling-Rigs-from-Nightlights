## Plotting functions for nightlights plotting with and without polygons
## requires libraries raster, sp, viridisLite


# plot only nightlights in the Northsea
plot_northsealights <- function(nightlightraster, seaboundaries){
  # create color palette
  mag <- magma(40)
  # plot
  plot(nightlightraster, useRaster = T, col = mag, panel.first = grid(lwd = 0.1))
  plot(seaboundaries, border = 'grey75', add = T)
  mtext(side = 1, "Longitude", line = 2.5, cex=1.1)
  mtext(side = 2, "Latitude", line = 2.5, cex=1.1)
  mtext(side = 3, "Drilling Rigs in the North Sea in 2012", line = 2.5, cex=1.5) 
  box()
}


# plot nightlights with shape boundaries of emmission on top in the Northsea
plot_northseaobjects <- function(nightlightraster, nightlightobjects, seaboundaries){
  plot_northsealights(nightlightraster, seaboundaries)  # use above function
  plot(nightlightobjects, border = 'lightgreen', add = T)
  mtext(side = 3, "with Emission Footprint per Rig", line = 0.9, cex=0.8)
}