#Read and process files
#This code will focus on reading the files associated corpus files, getting word frequencies, and processing the files
#We will use SQL to store the output in a much faster database to improve performance

library(RSQLite) #Library for the associated SQL functions
library(tm)
library(stringi)
library(magrittr)
source('Functions.R')

#File locations
file_blogs = "F:/My Documents/GitHub/Coursera-DataScienceCapstone/SwiftKey_DataFiles/en_US.blogs.txt"
file_news = "F:/My Documents/GitHub/Coursera-DataScienceCapstone/SwiftKey_DataFiles/en_US.news.txt"
file_twitter = "F:/My Documents/GitHub/Coursera-DataScienceCapstone/SwiftKey_DataFiles/en_US.twitter.txt"

#Read files
dataset_blogs <- readLines(file_blogs, encoding='UTF-8', warn=FALSE, skipNul=TRUE)
dataset_news <- readLines(file_news, encoding='UTF-8', warn=FALSE, skipNul=TRUE)
dataset_twitter <- readLines(file_twitter, encoding='UTF-8', warn=FALSE, skipNul=TRUE)

#Get the number of lines per file
lines_blogs <- length(dataset_blogs)
lines_news <- length(dataset_news)
lines_twitter <- length(dataset_twitter)

#Create the clean corpus
#Use small subset of all three datasets to stay under the appropriate filesize for shiny, this also greatly speeds up processing, will use 12% of each file
sample_blogs <- readLines(file_blogs, (lines_news*0.12), encoding='UTF-8', warn=FALSE, skipNul=TRUE)
sample_news <- readLines(file_news, (lines_news*0.12), encoding='UTF-8', warn=FALSE, skipNul=TRUE)
sample_twitter <- readLines(file_twitter, (lines_twitter*0.12), encoding='UTF-8', warn=FALSE, skipNul=TRUE)

#Merge the three data sets
dataset_sample <- c(sample_blogs, sample_news, sample_twitter)

#Create a clean corpus sample of all three files
##corpus_vector <- VectorSource(dataset_sample)
##clean_corpus <- Corpus(corpus_vector)
clean_corpus <- VCorpus(VectorSource(dataset_sample))

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

#Convert to a plaintext document, this should not be needed
clean_corpus <- tm_map(clean_corpus, PlainTextDocument)

  
#Create term document matrix for unigram, bigrams, trigrams, and quadgrams
tdm_unigram <- TermDocumentMatrix(clean_corpus, control = list(tokenize = UnigramTokenizer))
tdm_bigram <- TermDocumentMatrix(clean_corpus, control = list(tokenize = BigramTokenizer)) 
tdm_trigram <- TermDocumentMatrix(clean_corpus, control = list(tokenize = TrigramTokenizer))
tdm_quadgram <- TermDocumentMatrix(clean_corpus, control = list(tokenize = QuadgramTokenizer))
  
  
#Create SQL database
db <- dbConnect(SQLite(), dbname="shiny-prediction-app/corpus.db")
dbSendQuery(conn=db,
            "CREATE TABLE NGram
            (prediction TEXT,
             word TEXT,
             frequency INTEGER,
             number INTEGER)")

#Memory will overload if we do not remove terms with low frequency
tdm_unigram_cleaned <- (removeSparseTerms(tdm_unigram, 0.9995))
tdm_bigram_cleaned <- (removeSparseTerms(tdm_bigram, 0.99959))
tdm_trigram_cleaned <- (removeSparseTerms(tdm_trigram, 0.99986))
tdm_quadgram_cleaned <- (removeSparseTerms(tdm_quadgram, 0.999957))

#Create word frequencies, functions located in "Functions.R"
freq_quadgram <- getFrequency(tdm_quadgram_cleaned)
freq_trigram <- getFrequency(tdm_trigram_cleaned)
freq_bigram <- getFrequency(tdm_bigram_cleaned)
freq_unigram <- getFrequency(tdm_unigram_cleaned)

#Process with the word before and the current word
processNGram(freq_quadgram)
processNGram(freq_trigram)
processNGram(freq_bigram)
processNGram(freq_unigram)

#Insert results into database for faster processing in the application
sql_4 <- "INSERT INTO NGram VALUES ($before, $current, $frequency, 4)"
db_insert(sql_4, freq_quadgram)
sql_3 <- "INSERT INTO NGram VALUES ($before, $current, $frequency, 3)"
db_insert(sql_3, freq_trigram)
sql_2 <- "INSERT INTO NGram VALUES ($before, $current, $frequency, 2)"
db_insert(sql_2, freq_trigram)
sql_1 <- "INSERT INTO NGram VALUES ($before, $current, $frequency, 1)"
db_insert(sql_1, freq_unigram)

#disconnect and close the database
dbDisconnect(db)