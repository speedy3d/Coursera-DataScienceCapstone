Word Prediction Application - Stupid Backoff N-Gram Method
========================================================
author: Ryan Wissman
date: 10/8/2016
autosize: true

Introduction
========================================================

- Word prediction application created using Swiftkey datasets of twitter, news, and blog natural language text
- This application utilizes the N-gram model of natural language processing to take a user input and essentially "guess" the next relevant word in the string
- The final prediction model utilizes the Stupid Backup model in its final implementation. 
- There are limitations with this method and I was only able to use a very small subset of the data as applicaton database size and processing time were of utmost concern

Application link: https://speedy3d.shinyapps.io/shiny-prediction-app/ 

Using the application
========================================================

- The application is fairly straightfoward in that the user will input a string of text on the left, on the right the predicted next word will be highlighted in green. Screenshot is below:

![screenshot](screenshot.jpg)

The Algorithm - Stupid Backoff
========================================================

The application uses the Stupid Backoff model described by Brants et al 2007: http://www.aclweb.org/anthology/D07-1090.pdf

The model uses a backoff factor alpha that is heuristically set to a fixed value. This means that it does not need to be calculated which further reduces complexity. 
The Stupid Backoff method will first determine if a highest order n-gram is known and will utilize lower-order models (e.g., 4,3,2,1). For the purposes of this application we only utilized a database with quadgrams to save on size and increase speed. 

This model has a few advantages over other models, namely:

- **Fast**: Uses far fewer resources and is easier to implement than other algorithms such as Katz's Backoff Model
- **Accurate**: Good quality that approachs other methods such as Kneser-Ney

Designed for Speed
========================================================

Due to limited computing resources this applicaion needed to be designed for speed. Thus a few choices were made that limited the accuracy and depth of the prediction database. Thus the following choices were made:

- I utilized a SQLite database to store the n-grams and frequency table. The database size was limited to about 10mb to maintain high speed. 
- Due to memory and computing limitations 

References
========================================================
