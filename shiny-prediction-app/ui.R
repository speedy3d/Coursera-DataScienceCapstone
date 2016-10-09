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
           p("Enter a sentence, hit enter (or press the 'Predict next' button), and see what the 
             algorithm thinks will come next!"),
           p("The underlying model is an",
             a(href="http://en.wikipedia.org/wiki/N-gram", "n-gram"),
             "model, with quadgrams from a dataset of Twitter, news articles, 
             and blog posts. It uses 'Stupid Backoff'",
             a(href="http://www.cs.columbia.edu/~smaskey/CS6998-0412/supportmaterial/langmodel_mapreduce.pdf", 
               "(Brants et al 2007)"), "to deal with unseen n-grams.")),
  hr(),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      textInput("text", label = h3("Input"), value = "Happy"),
      helpText("Type in a sentence above, hit enter (or press the button below), and the results will display to the right."),
      submitButton("Predict next"),
      hr()
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      br(),
      h2(textOutput("sentence"), align="center"),
      h1(textOutput("predicted"), align="center", style="color:gray"),
      hr(),
      h3("Top 3 Possibilities:", align="center"),
      div(tableOutput("alts"), align="center")
    )
  )
  ))