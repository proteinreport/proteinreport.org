library(readr)
library(dplyr)
library(yaml)
library(here)
library(stringr)
library(urltools)
library(rlist)

# set working directory
setwd(here("content/english/news/"))

# read drupal data export into dataframe
import_data <- read_csv("news-export.csv") %>%
  as_tibble()
import_data$slug <- str_replace_all(import_data$slug,"/news/","")
import_data[is.na(import_data)] = ""
# fix date formatting
import_data$date <- as.character(import_data$date)

# loop through rows creating slug.md for each item
for (row in 1:nrow(import_data)) {
  # set file path
  file_path <- paste(basename(import_data[row,]$slug),".md", sep = "")
  # convert image field to list
  img_urls <- str_split(import_data[row,]$image, ", ")
  # decode image urls and add files path
  for (item in 1:length(img_urls[[1]])) {
    img_urls[[1]][item] = url_decode(basename(img_urls[[1]][item]))
    img_urls[[1]][item] = paste("/images/news/",img_urls[[1]][item], sep = "")
  }
  # replace image with first element of img_urls
  import_data[row,]$image <- img_urls[[1]][1]
  # create new column containing all img_urls
  import_data <- mutate(import_data, images = toString(img_urls[[1]]))

  # convert fields to yaml frontmatter
  fm <- select(import_data[row,],-body, -images, -tags) %>%
    as.yaml()
  # get body
  content <- select(import_data[row,], body) %>%
    as.character()
  # write to file
  write("---", file_path)
  write(fm, file_path, append = T)
  write(paste("images: [",import_data[row,]$images, "]", sep = ""), file_path, append = T)
  write(paste("tags: [", import_data[row,]$tags, "]", sep = ""), file_path, append = T)
  write("categories: [Marketing Activities]", file_path, append = T)
  write("---", file_path, append = T)
  write(content, file_path, append = T)
}
