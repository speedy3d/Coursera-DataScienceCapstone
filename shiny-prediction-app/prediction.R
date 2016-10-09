#Prediction functionality container file
#The prediction will be acomplished by using nGrams and the Stupid Backoff method

#Get the appropriate libraries
library(stringr)
library(RSQLite)
library(tm)

#Ngram backoff function
#This is from Brants et al 2007.
ngram_backoff <- function(raw, db) {
  #Find if n-gram has been seen, if not, multiply by alpha and back off
  #to lower gram model. Alpha unnecessary here, independent backoffs.
  
  max = 3  # max n-gram - 1
  
  #fix sentance issues
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
    names(predicted) <- c("Next Possible Word", "Score (Adjusted Freq)")
    print(predicted)
    
    if (nrow(predicted) > 0) return(predicted)
  }
  
  return("Sorry, I couldn't find anything")
}