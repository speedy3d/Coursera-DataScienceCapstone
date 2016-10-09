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
  titlePanel("Next Word Prediction Application"),
  h4("by Ryan Wissman", style="color:blue"),
  h3("Created for the JH Coursera Data Science Capstone Project"),
  hr(),
  
  fluidRow(width=2,
           p("Using the text input field below input any small sized sentence you like and the algorithm will predict which word will come next."),
           p("The model used by this algorithm is N-gram",
             a(href="http://en.wikipedia.org/wiki/N-gram", "n-gram"),
             "model, and used unigrams, bigrams, trigrams, and quadgrams derived from the SwiftKey dataset of blogs, twitter, and news text. It uses 'Stupid Backoff'",
             a(href="http://www.cs.columbia.edu/~smaskey/CS6998-0412/supportmaterial/langmodel_mapreduce.pdf", 
               "(Brants et al 2007)"), "to predict even when there are unknown N-grams."),
           p("Please note that this tool's prediction capability is limited. Due to processing power and memory limitations only a small subet of", 
             "data was used from the original Swiftkey dataset, roughly 3.5%. Total database contains roughly 30,000 N-gram observations")), 
  hr(),
  
  #Text input area
  sidebarLayout(
    sidebarPanel(
      textInput("text", label = h4("Enter Text:"), value = "Up"),
      helpText("Please type a sentence, the next predicted word will appear on the right in green."),
      submitButton("Predict next word"),
      hr()
    ),
    
    #Show the next three predicted words
    mainPanel(
      #h4("You Entered: ", align="center"), 
      #h3(textOutput("sentence"), align="center", style="color:gray"),
      #hr(),
      h3("Suggested Next Word: ", align="center"),
      h1(textOutput("predicted"), align="center", style="color:green"),
      hr(),
      h3("Top 3 Next Word Predictions:", align="center"),
      #h5("Associated score relates to frequency of predicted ngram in database as it relates to the input", align="center")
      div(tableOutput("alternatives"), align="center"),
      h5("Associated score relates to frequency of predicted ngram in database as it relates to the input", align="center")
    )
  )
  ))