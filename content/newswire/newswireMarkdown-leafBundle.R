library(readr)
library(dplyr)
library(yaml)
library(here)
library(stringr)
library(urltools)
library(rlist)

# set working directory
setwd(here("content/newswire"))

# read drupal data export into dataframe
import_data <- read_csv("newswire.csv") %>%
  as_tibble()
#import_data[is.na(import_data)] = ""
# fix date formatting
import_data$date <- as.character(import_data$date)
# decode apostrophe across entire data frame
import_data <- data.frame(lapply(import_data, function(x){gsub("&#039;", "'", x)}))
# decode ampersand across entire data frame
import_data <- data.frame(lapply(import_data, function(x){gsub("&amp;", "&", x)}))
# remove "/newswire" from slug
import_data$slug <- str_replace_all(import_data$slug, "/newswire", "")
# remove hidden line breaks from description
import_data$description <- str_replace_all(import_data$description, "[\r\n]" , "")
# replace NA with "" in image captions
import_data$image_caption[is.na(import_data$image_caption)] <- ""


# loop through rows creating index.md for each item
for (row in 1:nrow(import_data)) {
  # set directory based on slug
  dir_path <- paste(here("content/newswire"),import_data[row,]$slug,sep = "")
  # set file path
  file_path <- paste(dir_path,"/index.md",sep = "")
  # decode image url
  import_data[row,]$images <- url_decode(basename(import_data[row,]$images))
  # make list of additional images
  if (!(is.na(import_data[row,]$additional_images))) {
    # convert additional images field to list
    img_urls <- str_split(import_data[row,]$additional_images, ", ")
    # decode additional images urls
    for (item in 1:length(img_urls[[1]])) {
      img_urls[[1]][item] = shQuote(url_decode(basename(img_urls[[1]][item])))
    }
    # replace additional images with decoded image urls
    import_data[row,]$additional_images <- toString(img_urls[[1]])
  }
  # make list of additional image captions
  if (!(is.na(import_data[row,]$additional_images))) {
    # convert additional image captions field to list
    ## use regex to ignore comma delimiter inside quotes
    addtl_images_captions <- strsplit(import_data[row,]$additional_images_captions, '(,)(?=(?:[^"]|"[^"]*")*$)', perl = TRUE)
  }
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
  write("draft: false", file_path, append = T)
  write("pinned: false", file_path, append = T)
  write("homepage: false", file_path, append = T)
  write(paste("uuid: ",import_data[row,]$ID, sep = ""), file_path, append = T)
  #write("weight: 50", file_path, append = T)
  #write(images, file_path, append = T)
  #write("images:", file_path, append = T)
  #write(import_data[row,]$images, file_path, append = T)
  write("---", file_path, append = T)
  write(content, file_path, append = T)
}
