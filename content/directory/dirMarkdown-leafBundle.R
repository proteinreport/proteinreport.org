library(readr)
library(dplyr)
library(yaml)
library(here)
library(stringr)
library(urltools)
library(rlist)
library(rvest)
library(tidyverse)

# set working directory
setwd(here("content/directory"))

# read drupal data export into dataframe
import_data <- read_csv("directory.csv") %>%
  as_tibble()
# remove NA values
import_data$founded <- as.character(import_data$founded)
import_data <- replace(import_data, is.na(import_data), "")
# import_data[is.na(import_data)] = ""
# fix date formatting
import_data$date <- as.character(import_data$date)
# decode apostrophe across entire data frame
import_data <- data.frame(lapply(import_data, function(x){gsub("&#039;", "'", x)}))
# decode ampersand across entire data frame
import_data <- data.frame(lapply(import_data, function(x){gsub("&amp;", "&", x)}))
# remove hidden line breaks from description
import_data$description <- str_replace_all(import_data$description, "[\r\n]" , "")
# remove "/directory" from slug
import_data$slug <- str_replace_all(import_data$slug, "/directory", "")
# replace NA with "" in image captions
import_data$image_caption[is.na(import_data$image_caption)] <- ""

# loop through rows creating index.md for each item
for (row in 1:nrow(import_data)) {
  # set directory based on slug
  dir_path <- paste(here("content/directory"),import_data[row,]$slug,sep = "")
  # set file path
  file_path <- paste(dir_path,"/index.md",sep = "")
  # decode image url
  import_data[row,]$images <- url_decode(basename(import_data[row,]$images))
  # get body
  content <- select(import_data[row,], description) %>%
    as.character()
  # write to file
  write("---", file_path)
  #write(fm, file_path, append = T)
  write(paste("title: ", shQuote(import_data[row,]$title), sep = ""), file_path, append = T)
  write(paste("date: ", import_data[row,]$date, sep = ""), file_path, append = T)
  write(paste("lastmod: ", import_data[row,]$date, sep = ""), file_path, append = T)
  write(paste("slug: ", import_data[row,]$slug, sep = ""), file_path, append = T)
  write(paste("description: ", shQuote(import_data[row,]$description), sep = ""), file_path, append = T)
  # write(paste("excerpt: ", shQuote(import_data[row,]$description), sep = ""), file_path, append = T)
  write(paste("proteins: [",import_data[row,]$proteins, "]", sep = ""), file_path, append = T)
  write(paste("products: [",import_data[row,]$products, "]", sep = ""), file_path, append = T)
  write(paste("business: [",import_data[row,]$business, "]", sep = ""), file_path, append = T)
  if (!is.na(import_data[row,]$finance_type)) {
    write(paste("finance_type: [",import_data[row,]$finance_type, "]", sep = ""), file_path, append = T)
  }
  write(paste("country: ",shQuote(import_data[row,]$country), sep = ""), file_path, append = T)
  write(paste("country_code: ",shQuote(import_data[row,]$country_code), sep = ""), file_path, append = T)
  write(paste("city: ",shQuote(import_data[row,]$city), sep = ""), file_path, append = T)
  write(paste("location: [",import_data[row,]$geolocation, "]", sep = ""), file_path, append = T)
  write(paste("founded: ",import_data[row,]$founded, sep = ""), file_path, append = T)
  write(paste("founders: ",shQuote(import_data[row,]$founders), sep = ""), file_path, append = T)
  # write(paste("flags: [",import_data[row,]$flags, "]", sep = ""), file_path, append = T)
  # write(paste("directory: [",import_data[row,]$directory, "]", sep = ""), file_path, append = T)
  # write(paste("company: ", shQuote(import_data[row,]$company), sep = ""), file_path, append = T)
  write(paste("featured_image: ", shQuote(import_data[row,]$images), sep = ""), file_path, append = T)
  # write(paste("additional_images: [",import_data[row,]$additional_images, "]", sep = ""), file_path, append = T)
  #write(paste("images:", sep=""), file_path, append = T)
  #write(paste("  - src: ", shQuote(import_data[row,]$images),
  #            "\n    caption: ", shQuote(import_data[row,]$image_caption),
  #            "\n    alt: ", shQuote(import_data[row,]$image_caption),
  #            "\n    title: ", shQuote(import_data[row,]$image_caption),
  #            sep = ""), file_path, append = T)
  write(paste("website: ",import_data[row,]$website, sep = ""), file_path, append = T)
  write(paste("linkedin: ",import_data[row,]$linkedin, sep = ""), file_path, append = T)
  write(paste("twitter: ",import_data[row,]$twitter, sep = ""), file_path, append = T)
  write(paste("instagram: ",import_data[row,]$instagram, sep = ""), file_path, append = T)
  write(paste("facebook: ",import_data[row,]$facebook, sep = ""), file_path, append = T)
  write(paste("youtube: ",import_data[row,]$youtube, sep = ""), file_path, append = T)
  write(paste("crunchbase: ",import_data[row,]$crunchbase, sep = ""), file_path, append = T)
  write("draft: false", file_path, append = T)
  write("pinned: false", file_path, append = T)
  write("homepage: false", file_path, append = T)
  write("weight: 5000", file_path, append = T)
  write(paste("uuid: ",import_data[row,]$ID, sep = ""), file_path, append = T)
  #write(images, file_path, append = T)
  #write("images:", file_path, append = T)
  #write(import_data[row,]$images, file_path, append = T)
  write("---", file_path, append = T)
  write(content, file_path, append = T)
}
