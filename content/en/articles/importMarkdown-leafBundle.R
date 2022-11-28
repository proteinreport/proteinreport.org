library(readr)
library(dplyr)
library(yaml)
library(here)
library(stringr)
library(urltools)
library(rlist)

# set working directory
setwd(here("content/en/articles"))

# read drupal data export into dataframe
import_data <- read_csv("featured.csv") %>%
  as_tibble()
import_data[is.na(import_data)] = ""
# fix date formatting
import_data$date <- as.character(import_data$date)
# decode apostrophe
import_data$title <- str_replace_all(import_data$title, "&#039;", "'")

# loop through rows creating index.md for each item
for (row in 1:nrow(import_data)) {
  # set directory based on slug
  dir_path <- paste(here("content/en/articles"),import_data[row,]$slug,sep = "")
  # set file path
  file_path <- paste(dir_path,"/index.md",sep = "")
  # convert image field to list
  # img_urls <- str_split(import_data[row,]$images, ", ")
  # decode image url
  import_data[row,]$images <- url_decode(basename(import_data[row,]$images))
  # for (item in 1:length(img_urls[[1]])) {
    # img_urls[[1]][item] = url_decode(basename(img_urls[[1]][item]))
  # }
  # replace image with first element of img_urls
  #import_data[row,]$images <- img_urls[[1]][1]
  # create new column containing remaining elements of img_urls
  #import_data <- mutate(import_data, images = paste("[", toString(img_urls[[1]]), "]", sep=""))
  #import_data <- mutate(import_data, images = as.yaml(img_urls[[1]]))
  #import_data[row,]$images <- noquote(paste('[',import_data[row,]$images,']', sep = ""))
  #import_data[row,]$images <- str_replace_all(import_data[row,]$images, "\'", "")
  #import_data[row,]$images <- print(import_data[row,]$images, quote = F)
  #import_data <- mutate(import_data, images = img_urls[[1]])
  # convert image list back to char and add []
  #img_urls <- paste("[", unlist(img_urls), "]")
  #import_data[row,]$image <- img_urls
  
  # convert fields to yaml frontmatter
  # fm <- select(import_data[row,],-body, -images, -proteins, -products, -topics, -regions, -flags, -directory, -contributors, -videos) %>%
  #  as.yaml()
  #images <- select(import_data[row,],images) %>%
  #  as.yaml()
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
  write(paste("excerpt: ", shQuote(import_data[row,]$description), sep = ""), file_path, append = T)
  write(paste("proteins: [",import_data[row,]$proteins, "]", sep = ""), file_path, append = T)
  write(paste("products: [",import_data[row,]$products, "]", sep = ""), file_path, append = T)
  write(paste("topics: [",import_data[row,]$topics, "]", sep = ""), file_path, append = T)
  write(paste("regions: [",import_data[row,]$regions, "]", sep = ""), file_path, append = T)
  write(paste("flags: [",import_data[row,]$flags, "]", sep = ""), file_path, append = T)
  write(paste("directory: [",import_data[row,]$directory, "]", sep = ""), file_path, append = T)
  write(paste("contributors: [",import_data[row,]$contributors, "]", sep = ""), file_path, append = T)
  write(paste("images: [",import_data[row,]$images, "]", sep = ""), file_path, append = T)
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


#%>%
# make image array by adding [] to image column
#mutate(image = paste("[", image, "]", sep = ""))

# replace all double spaces with single space
#import_data$description <- str_replace_all(import_data$description, "  ", " ")
#import_data$body <- str_replace_all(import_data$body, "  ", " ")
