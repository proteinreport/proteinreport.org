library(readr)
library(dplyr)
library(yaml)
library(here)
library(stringr)
library(urltools)
library(rlist)

# set working directory
setwd(here("content/en/events"))

# read drupal data export into dataframe
import_data <- read_csv("events.csv") %>%
  as_tibble()
#import_data[is.na(import_data)] = ""
# fix date formatting
import_data$date <- as.character(import_data$date)
# decode apostrophe
import_data$title <- str_replace_all(import_data$title, "&#039;", "'")
# remove "/directory" from slug
import_data$slug <- str_replace_all(import_data$slug, "/events", "")

# loop through rows creating index.md for each item
for (row in 1:nrow(import_data)) {
  # set directory based on slug
  dir_path <- paste(here("content/en/events"),import_data[row,]$slug,sep = "")
  # set file path
  file_path <- paste(dir_path,"/index.md",sep = "")
  # decode image url
  import_data[row,]$images <- url_decode(basename(import_data[row,]$images))
  # decode banner image url
  import_data[row,]$banner_image <- url_decode(basename(import_data[row,]$banner_image))
  # get body
  content <- select(import_data[row,], body) %>%
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
  write(paste("topics: [",import_data[row,]$topics, "]", sep = ""), file_path, append = T)
  write(paste("regions: [",import_data[row,]$regions, "]", sep = ""), file_path, append = T)
  write(paste("images: [", shQuote(import_data[row,]$images), "]", sep = ""), file_path, append = T)
  write(paste("banner_image: ", shQuote(import_data[row,]$banner_image), sep = ""), file_path, append = T)
  write(paste("online: ",import_data[row,]$online, sep = ""), file_path, append = T)
  write(paste("start_date: ",import_data[row,]$start_date, sep = ""), file_path, append = T)
  write(paste("end_date: ",import_data[row,]$end_date, sep = ""), file_path, append = T)
  if (!is.na(import_data[row,]$country)) {
    write(paste("country: ",import_data[row,]$country, sep = ""), file_path, append = T)
  }
  if (!is.na(import_data[row,]$city)) {
    write(paste("city: ",import_data[row,]$city, sep = ""), file_path, append = T)
  }
  #write(paste("country: [",import_data[row,]$country, "]", sep = ""), file_path, append = T)
  #write(paste("city: [",import_data[row,]$city, "]", sep = ""), file_path, append = T)
  write(paste("website: ", shQuote(import_data[row,]$website), sep = ""), file_path, append = T)
  write(paste("contributors: [",import_data[row,]$contributors, "]", sep = ""), file_path, append = T)
  write("draft: false", file_path, append = T)
  #write("pinned: false", file_path, append = T)
  #write("homepage: false", file_path, append = T)
  write("weight: ", file_path, append = T)
  #write(images, file_path, append = T)
  #write("images:", file_path, append = T)
  #write(import_data[row,]$images, file_path, append = T)
  write("---", file_path, append = T)
  write(content, file_path, append = T)
}
