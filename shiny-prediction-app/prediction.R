#Prediction functionality container file
#The prediction will be acomplished by using nGrams and the Stupid Backoff method

#Get the appropriate libraries
library(stringr)
library(RSQLite)
library(tm)

#Ngram stupid backoff method
#This is from Brants et al 200: http://www.aclweb.org/anthology/D07-1090.pdf.
ngramStupidBackoff <- function(userInputSentence, db) {
  
  #fix potential sentance issues from user input before we start the prediction
  sentence <- tolower(userInputSentence) %>% removePunctuation %>% removeNumbers %>% stripWhitespace %>% str_trim %>% strsplit(split=" ") %>% unlist
  
  #get prediction
  #set the max for the loop
  # Even though prediction capable up to quadgrams, max for for loop is 2 which appears to give better predictions
  maximum = 2
  for (cNum in min(length(sentence), maximum):1) {
    foundGram <- paste(tail(sentence, cNum), collapse=" ")
    
    #Try to match to a prediction in the corpus.db SQL database, SQL greatly speeds up retrieval
    sql <- paste("SELECT word, frequency FROM NGram WHERE ", " prediction=='", paste(foundGram), "'", " AND number==", cNum + 1, " LIMIT 3", sep="")
    
    #Retrieve the result
    result <- dbSendQuery(conn=db, sql)
    predicted <- dbFetch(result, n=-1)
    names(predicted) <- c("Another Possible Word", "Prediction Score")
    print(predicted)
    
    #if we get a prediction, return
    if (nrow(predicted) > 0) 
      return(predicted)
  }
  
  #If unable to find any words
  return("Sorry, no prediction is available.")
}