## Preprocessing of nightlight data, including download and unzipping
## mosaicking to northsea extent is done in bash script for linux
## northsea boundaries are buffered by 25 km, this might be time-consuming
## requires libraries raster, rgdal, sp

preprocess_nightlights <- function(){
  
  # Download from the global 2012 nightlight composite the two tiles that contain parts of the North Sea
  datadir <- 'data'
  checkdir(datadir)
  urlC1 <- 'http://eoimages.gsfc.nasa.gov/images/imagerecords/79000/79765/dnb_land_ocean_ice.2012.13500x13500.C1_geo.tif '
  urlB1 <- 'http://eoimages.gsfc.nasa.gov/images/imagerecords/79000/79765/dnb_land_ocean_ice.2012.13500x13500.B1_geo.tif '
  urlnorthsea <- 'http://geo.vliz.be/geoserver/wms?request=GetMap&service=wms&version=1.1.1&srs=EPSG:4326&layers=MarineRegions:iho&width=800&height=492&bbox=-4.44537067411719,50.995364665547,12.0059423445637,61.0170228484258&styles=gazetteer_red&Format=KML&filter=%3CPropertyIsEqualTo%3E%3CPropertyName%3Eid%3C%2FPropertyName%3E%3CLiteral%3E4%3C%2FLiteral%3E%3C%2FPropertyIsEqualTo%3E'
  urlnorthsea <- 'http://geo.vliz.be/geoserver/wfs?request=getfeature&service=wfs&version=1.0.0&typename=MarineRegions:iho&outputformat=SHAPE-ZIP&filter=%3CPropertyIsEqualTo%3E%3CPropertyName%3Eid%3C%2FPropertyName%3E%3CLiteral%3E4%3C%2FLiteral%3E%3C%2FPropertyIsEqualTo%3E'
  
  nightlightC1 <- 'nightlightsmiddleearthc1.tif'
  nightlightB1 <- 'nightlightsmiddleearthb1.tif'
  northseamaskzip <- 'northsea.zip'
  
  getsourcedata(urlC1, datadir, nightlightC1)
  getsourcedata(urlB1, datadir, nightlightB1)
  getsourcedata(urlnorthsea, datadir, northseamaskzip)
  
  northseadir <- file.path(datadir, 'northsea')
  northseamask <- unzip(file.path(datadir, northseamaskzip), exdir = northseadir)
  
  # mosaic the North Sea from these two tiles and mosaic them together in the coarse extent of the North Sea (cropping exatcly will be done later)
  # bashing gdalwarp
  mosaicname <- 'nightlightsb1c1'
  mosaicfile <- paste0(mosaicname, '.tif')
  bashmosaic <- paste('gdalwarp -te -5  50.5 12.5 62', file.path(datadir, nightlightB1), file.path(datadir, nightlightC1), file.path(datadir, mosaicfile))
  system(bashmosaic)
  
  # load north sea nightlights together as well as single bands
  nightlightsnorthsea <- brick(file.path(datadir, mosaicfile))
  
  # load the north sea vector dataset, reproject it
  northseafile <- list.files(northseadir, pattern = glob2rx('*.shp'), full.names = T)
  northsea <- readOGR(northseafile, layer = 'iho')
  northsea_proj <- reproject_on_CRS(northsea)
  # buffering northsea towards sea (inside) with 25 km, reproject back
  smoothnorthsea <- gBuffer(northsea_proj, byid = TRUE, width = -25)
  smoothnorthsea_ll <- reproject_on_obj(smoothnorthsea, nightlightsnorthsea)
  
  # mask nightlights with buffered north sea
  nlcoastcleared <- mask(nightlightsnorthsea, smoothnorthsea_ll, filename = file.path(datadir, 'nightlightscoastcleared.tif'))
  
  return (nlcoastcleared)
  
}