## requires library sp

# reproject into reference system of a given file
reproject_on_obj <- function (object, projected_object) {
  prj_string_RD <- proj4string(projected_object)
  reprojected <- spTransform(object, prj_string_RD)
  return (reprojected)
}


# reproject input to projected system centered to North Sea
reproject_on_CRS <- function (object) {
  prj_string_RD <- CRS('+proj=sterea +lat_0=56.5 +lon_0=2.8 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +units=km +no_defs')
  reprojected <- spTransform(object, prj_string_RD)
  return (reprojected)
}
