library(readr)
library(dplyr)
library(yaml)
library(here)
library(stringr)
library(urltools)
library(rlist)

# set working directory
setwd(here("content/en/newswire"))

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


# loop through rows creating index.md for each item
for (row in 1:nrow(import_data)) {
  # set directory based on slug
  dir_path <- paste(here("content/en/newswire"),import_data[row,]$slug,sep = "")
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
  if (!(is.na(import_data[row,]$company))) {
    write(paste("company: ", import_data[row,]$company, sep = ""), file_path, append = T)
  }
  else if (!(is.na(import_data[row,]$company_name))) {
    write(paste("company_name: ", shQuote(import_data[row,]$company_name), sep = ""), file_path, append = T)
    write(paste("company_link: ", shQuote(import_data[row,]$company_link), sep = ""), file_path, append = T)
  }
  write(paste("description: ", shQuote(import_data[row,]$description), sep = ""), file_path, append = T)
  write(paste("excerpt: ", shQuote(import_data[row,]$description), sep = ""), file_path, append = T)
  write(paste("proteins: [",import_data[row,]$proteins, "]", sep = ""), file_path, append = T)
  write(paste("products: [",import_data[row,]$products, "]", sep = ""), file_path, append = T)
  write(paste("topics: [",import_data[row,]$topics, "]", sep = ""), file_path, append = T)
  write(paste("regions: [",import_data[row,]$regions, "]", sep = ""), file_path, append = T)
  write(paste("flags: [",import_data[row,]$flags, "]", sep = ""), file_path, append = T)
  write(paste("directory: [",import_data[row,]$directory, "]", sep = ""), file_path, append = T)
  #write(paste("contributors: [",import_data[row,]$contributors, "]", sep = ""), file_path, append = T)
  write(paste("images: [", shQuote(import_data[row,]$images), "]", sep = ""), file_path, append = T)
  write(paste("additional_images: [",import_data[row,]$additional_images, "]", sep = ""), file_path, append = T)
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
