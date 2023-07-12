library(readr)
library(dplyr)
library(yaml)
library(here)
library(stringr)
library(urltools)

# set working directory
setwd(here("content/directory/"))

# read drupal data export into dataframe
import_data <- read_csv("directory.csv") 

# remove "/newswire" from slug
import_data$slug <- str_replace_all(import_data$slug, "/directory", "")

# loop through rows creating hugo leaf bundle directories with images for each news item
for (row in 1:nrow(import_data)) {
  # create directory based on slug
  dir_path <- paste(here("content/directory"),import_data[row,]$slug,sep = "")
  dir.create(dir_path)
  # get lead image
  if (!is.na(import_data[row,]$images)) {
    img_urls <- as.list(str_split(import_data[row,]$images, ", "))
    for (item in 1:length(img_urls[[1]])) {
      img_path <- paste(dir_path, basename(img_urls[[1]][item]), sep="/")
      #check if we already have it locally
      if (!file.exists(url_decode(img_path))) {
        tryCatch(
          download.file(img_urls[[1]][item], url_decode(img_path), mode = 'wb'),
          error = function(e) print(paste(img_path, 'file was not found on pr server'))
        )
      }
    }
  }
}
