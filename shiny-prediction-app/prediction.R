#Prediction functionality container file
#The prediction will be acomplished by using nGrams and the Stupid Backoff method

#Get the appropriate libraries
library(stringr)
library(RSQLite)
library(tm)

#Ngram stupid backoff method
#This is from Brants et al 200: http://www.aclweb.org/anthology/D07-1090.pdf.
ngramStupidBackoff <- function(raw, db) {
  #Find if n-gram has been seen, if not, multiply by alpha and back off
  #to lower gram model. Alpha unnecessary here, independent backoffs.
  
  #Prediction capable up to quadgrams, thus max for for loop is 3
  max = 3  
  
  #fix sentance issues from user input
  sentence <- tolower(raw) %>%
    removePunctuation %>%
    removeNumbers %>%
    stripWhitespace %>%
    str_trim %>%
    strsplit(split=" ") %>%
    unlist
  

  #get prediction
  for (i in min(length(sentence), max):1) {
    gram <- paste(tail(sentence, i), collapse=" ")
    sql <- paste("SELECT word, frequency FROM NGram WHERE ", 
                 " prediction=='", paste(gram), "'",
                 " AND number==", i + 1, " LIMIT 3", sep="")
    res <- dbSendQuery(conn=db, sql)
    predicted <- dbFetch(res, n=-1)
    names(predicted) <- c("Another Possible Word", "Prediction Score")
    print(predicted)
    
    if (nrow(predicted) > 0) 
      return(predicted)
  }
  
  return("Sorry, no prediction is available.")
}

#paste(gram)