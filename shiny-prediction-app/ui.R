#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Word Prediction Application"),
  h4("by Ryan Wissman", style="color:blue"),
  hr(),
  
  fluidRow(width=3,
           p("Using the text input field below input any small sized sentence you like and the algorithm will predict which word will come next."),
           p("The model used by this algorithm is N-gram",
             a(href="http://en.wikipedia.org/wiki/N-gram", "n-gram"),
             "model, and used unigrams, bigrams, trigrams, and quadgrams derived from the SwiftKey dataset. It uses 'Stupid Backoff'",
             a(href="http://www.cs.columbia.edu/~smaskey/CS6998-0412/supportmaterial/langmodel_mapreduce.pdf", 
               "(Brants et al 2007)"), "to predict even when there are unknown N-grams"),
           p("Please note that this tool's prediction capability is limited. Due to processing power and memory limitations only a small subet of", 
             "data was used from the original Swiftkey dataset, roughly 3.5%")), 
  hr(),
  
  # Text input area
  sidebarLayout(
    sidebarPanel(
      textInput("text", label = h3("Input"), value = "Here we"),
      helpText("Please type a sentence, the next predicted word will appear on the right."),
      submitButton("Predict next word"),
      hr()
    ),
    
    # Show the next three predicted words
    mainPanel(
      br(),
      h2(textOutput("sentence"), align="center"),
      h1(textOutput("predicted"), align="center", style="color:blue"),
      hr(),
      h3("Top 3 Possibilities:", align="center"),
      div(tableOutput("alternatives"), align="center")
    )
  )
  ))