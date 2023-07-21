library(readr)
library(dplyr)
library(yaml)
library(here)
library(stringr)
library(urltools)
library(rlist)

# set working directory
setwd(here("content/jobs"))

# read drupal data export into dataframe
import_data <- read_csv("jobs.csv") %>%
  as_tibble()
# fix date formatting
import_data$date <- as.character(import_data$date)
import_data$closing_date <- as.character(import_data$closing_date)
# remove NA values
import_data$company <- as.character(import_data$company)
import_data <- replace(import_data, is.na(import_data), "")
# decode apostrophe across entire data frame
import_data <- data.frame(lapply(import_data, function(x){gsub("&#039;", "'", x)}))
# decode ampersand across entire data frame
import_data <- data.frame(lapply(import_data, function(x){gsub("&amp;", "&", x)}))
# remove hidden line breaks from description
import_data$description <- str_replace_all(import_data$description, "[\r\n]" , "")
# remove "/jobs" from slug (keep this path as hugo alias)
import_data$slug <- str_replace_all(import_data$slug, "/jobs", "")
# replace NA with "" in image captions
# import_data$image_caption[is.na(import_data$image_caption)] <- ""

# make new slug including uuid
import_data$slug_new <- paste(basename(import_data$slug),import_data$ID, sep = "-")

# loop through rows creating index.md for each item
for (row in 1:nrow(import_data)) {
  # set directory based on slug
  dir_path <- paste(here("content/jobs"),import_data[row,]$slug_new,sep = "/")
  # set file path
  file_path <- paste(dir_path,"/index.md",sep = "")
  # decode image url
  #import_data[row,]$images <- url_decode(basename(import_data[row,]$images))
  # get body and convert html to markdown
  content <- select(import_data[row,], body) %>%
    as.character()
  content <- pandoc::pandoc_convert(text = content, from="html", to="markdown")
  # get how to apply and convert html to markdown
  how_to_apply <- select(import_data[row,], how_to_apply) %>%
    as.character()
  how_to_apply <- pandoc::pandoc_convert(text = how_to_apply, from="html", to="markdown")
  # write to file
  write("---", file_path)
  #write(fm, file_path, append = T)
  write(paste("title: ", shQuote(import_data[row,]$title), sep = ""), file_path, append = T)
  write(paste("date: ", import_data[row,]$date, sep = ""), file_path, append = T)
  write(paste("closing_date: ", import_data[row,]$closing_date, sep = ""), file_path, append = T)
  write(paste("lastmod: ", import_data[row,]$date, sep = ""), file_path, append = T)
  write(paste("slug: ", import_data[row,]$slug_new, sep = ""), file_path, append = T)
  if (import_data[row,]$company != "") {
    write(paste("company: ", import_data[row,]$company, sep = ""), file_path, append = T)
  }
  else if (import_data[row,]$company_name != "") {
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
  write(paste("job_type: [",import_data[row,]$job_type, "]", sep = ""), file_path, append = T)
  write(paste("remote: ",import_data[row,]$remote, sep = ""), file_path, append = T)
  write(paste("work_environment: [",import_data[row,]$work_environment, "]", sep = ""), file_path, append = T)
  write(paste("work_hours: [",import_data[row,]$work_hours, "]", sep = ""), file_path, append = T)
  write(paste("career_category: [",import_data[row,]$career_category, "]", sep = ""), file_path, append = T)
  write(paste("city: ",shQuote(import_data[row,]$city), sep = ""), file_path, append = T)
  write(paste("country: ",shQuote(import_data[row,]$country), sep = ""), file_path, append = T)
  write(paste("country_code: ",shQuote(import_data[row,]$country_code), sep = ""), file_path, append = T)
  write(paste("how_to_apply: ",shQuote(how_to_apply), sep = ""), file_path, append = T)
  write(paste("application_link: ",shQuote(import_data[row,]$application_link), sep = ""), file_path, append = T)
  #write(paste("contributors: [",import_data[row,]$contributors, "]", sep = ""), file_path, append = T)
  write(paste("images: [", "]", sep = ""), file_path, append = T)
  #write(paste("additional_images: [",import_data[row,]$additional_images, "]", sep = ""), file_path, append = T)
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
