# function for downloading files from a given url

getsourcedata <- function (link, destdir, filename) {
  file <- paste0(destdir, '/', filename)
  download.file(url=link, destfile=file, method='auto')
}

