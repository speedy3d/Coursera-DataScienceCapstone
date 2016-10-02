#Read and process files
#This code will focus on reading the files associated corpus files, getting word frequencies, and processing the files
#We will use SQL to store the output in a much faster database to improve performance

library(RSQLite) #Library for the associated SQL functions
library(tm)
library(stringi)
source('Functions.R')

#Read files
file_blogs = "F:/My Documents/GitHub/Coursera-DataScienceCapstone/SwiftKey_DataFiles/en_US.blogs.txt"
file_news = "F:/My Documents/GitHub/Coursera-DataScienceCapstone/SwiftKey_DataFiles/en_US.news.txt"
file_twitter = "F:/My Documents/GitHub/Coursera-DataScienceCapstone/SwiftKey_DataFiles/en_US.twitter.txt"

dataset_blogs <- readLines(file_blogs, encoding='UTF-8', warn=FALSE, skipNul=TRUE)
dataset_news <- readLines(file_news, encoding='UTF-8', warn=FALSE, skipNul=TRUE)
dataset_twitter <- readLines(file_twitter, encoding='UTF-8', warn=FALSE, skipNul=TRUE)