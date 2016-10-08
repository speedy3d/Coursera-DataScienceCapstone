#File that contains associated NLP functions used in the ReadANdProcess.R file

#Required libraries
library(RWeka)
library(data.table)


#This function will take a TermDocumentMatrix and transform into a frequency table
getFrequency <- function(tdm) {
  frequency <- sort(rowSums(tdm, na.rm=TRUE), decreasing=TRUE)
  word <- names(frequency)
  data.table(word=word, frequency=frequency)
}


#Process the nGram such that it is added to the table with a beforeword and the current word





































UnigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
TrigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
QuadgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))