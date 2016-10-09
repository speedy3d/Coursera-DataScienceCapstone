#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(RSQLite)
source('prediction.R')

shinyServer(function(input, output) {
  # input$text and input$action are available
  # output$sentence and output$predicted should be made available
  db <- dbConnect(SQLite(), dbname="corpus.db")
  dbout <- reactive({ngram_backoff(input$text, db)})
  
  output$sentence <- renderText({input$text})
  output$predicted <- renderText({
    out <- dbout()
    if (out[[1]] == "Sorry, I couldn't find anything") {
      return(out)
    } else {
      return(unlist(out)[1])
    }})
  output$alts <- renderTable({dbout()})
})