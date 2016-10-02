#Read and process files
#This code will focus on reading the files associated corpus files, getting word frequencies, and processing the files
#We will use SQL to store the output in a much faster database to improve performance

library(RSQLite) #Library for the associated SQL functions
library(tm)
library(stringi)
source('Functions.R')

#File locations
file_blogs = "F:/My Documents/GitHub/Coursera-DataScienceCapstone/SwiftKey_DataFiles/en_US.blogs.txt"
file_news = "F:/My Documents/GitHub/Coursera-DataScienceCapstone/SwiftKey_DataFiles/en_US.news.txt"
file_twitter = "F:/My Documents/GitHub/Coursera-DataScienceCapstone/SwiftKey_DataFiles/en_US.twitter.txt"

#Create clean corpus
  #Create small samples of all three datasets, this greatly speeds up processing, will use 10% of each file
  sample_blogs <- readLines(file_blogs, (lines_blogs*0.10), encoding='UTF-8', warn=FALSE, skipNul=TRUE)
  sample_news <- readLines(file_news, (lines_news*0.10), encoding='UTF-8', warn=FALSE, skipNul=TRUE)
  sample_twitter <- readLines(file_twitter, (lines_twitter*0.10), encoding='UTF-8', warn=FALSE, skipNul=TRUE)
  
  #Merge the three data sets
  dataset_sample <- c(sample_blogs, sample_news, sample_twitter)
  
  #Create a clean corpus sample of all three files
  corpus_vector <- VectorSource(dataset_sample)
  clean_corpus <- Corpus(corpus_vector)
  
  #Make sure encoding is correct and clean some issues related to emojis in the dataset
  clean_corpus <- tm_map(clean_corpus, function(x) iconv(x, to='UTF-8', sub='byte'))
  
  #Clean punctuation marks
  clean_corpus <- tm_map(clean_corpus, removePunctuation)
  
  #Remove numbers
  clean_corpus <- tm_map(clean_corpus, removeNumbers)
  
  #Remove extra whitespace
  clean_corpus <- tm_map (clean_corpus, stripWhitespace)
  
  #Remove english stopwords, this is probably not needed but I will leave this code here
  #clean_corpus <- tm_map(clean_corpus, removeWords, stopwords("english")) 
  
  #Convert all letters to lowercase
  clean_corpus <- tm_map(clean_corpus, tolower)
  
  #Convert to a plaintext document
  clean_corpus <- tm_map(clean_corpus, PlainTextDocument)