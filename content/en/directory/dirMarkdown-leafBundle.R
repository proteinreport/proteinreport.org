library(readr)
library(dplyr)
library(yaml)
library(here)
library(stringr)
library(urltools)
library(rlist)

# set working directory
setwd(here("content/en/directory"))

# read drupal data export into dataframe
import_data <- read_csv("directory.csv") %>%
  as_tibble()
import_data[is.na(import_data)] = ""
# fix date formatting
import_data$date <- as.character(import_data$date)
# decode apostrophe
import_data$title <- str_replace_all(import_data$title, "&#039;", "'")
# remove "/directory" from slug
import_data$slug <- str_replace_all(import_data$slug, "/directory", "")

# loop through rows creating index.md for each item
for (row in 1:nrow(import_data)) {
  # set directory based on slug
  dir_path <- paste(here("content/en/directory"),import_data[row,]$slug,sep = "")
  # set file path
  file_path <- paste(dir_path,"/index.md",sep = "")
  # decode image url
  import_data[row,]$images <- url_decode(basename(import_data[row,]$images))
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
  write(paste("business: [",import_data[row,]$business, "]", sep = ""), file_path, append = T)
  if (!is.na(import_data[row,]$finance_type)) {
    write(paste("finance_type: [",import_data[row,]$finance_type, "]", sep = ""), file_path, append = T)
  }
  write(paste("regions: [",import_data[row,]$regions, "]", sep = ""), file_path, append = T)
  write(paste("location: [",import_data[row,]$location, "]", sep = ""), file_path, append = T)
  # write(paste("flags: [",import_data[row,]$flags, "]", sep = ""), file_path, append = T)
  # write(paste("directory: [",import_data[row,]$directory, "]", sep = ""), file_path, append = T)
  # write(paste("company: ", shQuote(import_data[row,]$company), sep = ""), file_path, append = T)
  write(paste("images: [", shQuote(import_data[row,]$images), "]", sep = ""), file_path, append = T)
  # write(paste("additional_images: [",import_data[row,]$additional_images, "]", sep = ""), file_path, append = T)
  write("draft: false", file_path, append = T)
  write("pinned: false", file_path, append = T)
  write("homepage: false", file_path, append = T)
  write("weight: 5000", file_path, append = T)
  #write(images, file_path, append = T)
  #write("images:", file_path, append = T)
  #write(import_data[row,]$images, file_path, append = T)
  write("---", file_path, append = T)
  write(content, file_path, append = T)
}
