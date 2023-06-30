library(readr)
library(dplyr)
library(yaml)
library(here)
library(stringr)
library(urltools)

# set working directory
#setwd(here("content/english/news/"))

# read drupal data export into dataframe
import_data <- read_csv("news-export.csv") 

# loop through rows creating hugo leaf bundle directories with images for each news item
for (row in 1:nrow(import_data)) {
  # create directory based on slug
  dir_path <- paste(here("static/files/"))
  #get images
  if (!is.na(import_data[row,]$image)) {
    img_urls <- as.list(str_split(import_data[row,]$image, ", "))
    for (item in 1:length(img_urls[[1]])) {
      img_path <- paste(dir_path, basename(img_urls[[1]][item]), sep="/")
      #check if we already have it locally
      if (!file.exists(url_decode(img_path))) {
        tryCatch(
          download.file(img_urls[[1]][item], url_decode(img_path), mode = 'wb'),
          error = function(e) print(paste(img_path, 'file was not found on mzmc server'))
        )
      }
    }
  }
}
