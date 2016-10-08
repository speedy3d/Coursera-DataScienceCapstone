#File that contains associated NLP functions used in the ReadANdProcess.R file

#Required libraries
library(RWeka)
library(data.table)


#This function will take a TermDocumentMatrix and transform into a frequency table
getFrequency <- function(tdm) {
  frequency <- sort(rowSums(as.matrix(tdm), na.rm=TRUE), decreasing=TRUE)
  word <- names(frequency)
  data.table(word=word, frequency=frequency)
}


#Process the nGram such that it is added to the table with a before word and the current word
processNGram <- function(theTable) {
  theTable[, c("before", "current"):=list(unlist(strsplit(word, "[ ]+?[a-z]+$")), 
                             unlist(strsplit(word, "^([a-z]+[ ])+"))[2]), 
     by=word]
}


#insert results into database
db_insert <- function(sql, key_counts)
{
  dbBegin(db)
  dbGetPreparedQuery(db, sql, bind.data = key_counts)
  dbCommit(db)
}



UnigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
TrigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
QuadgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))