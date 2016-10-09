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
  #connect to the database
  db <- dbConnect(SQLite(), dbname="corpus.db")
  
  #Use ngramBackoff function found witin prediction.R a a reaction
  dbout <- reactive({ngramBackoff(input$text, db)})
  
  output$sentence <- renderText({input$text})
  output$predicted <- renderText({
    out <- dbout()
    if (out[[1]] == "Sorry, no prediction is available.") {
      return(out)
    } else {
      return(unlist(out)[1])
    }})
  output$alts <- renderTable({dbout()})
})