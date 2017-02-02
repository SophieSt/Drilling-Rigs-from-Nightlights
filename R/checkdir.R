## create any required directories for the project

checkdir <- function (directory) {
  ifelse (!dir.exists(directory), dir.create(directory), FALSE)
}
