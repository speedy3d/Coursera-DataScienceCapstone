#Read and process files
#This code will focus on reading the files associated corpus files, getting word frequencies, and processing the files
#We will use SQL to store the output in a much faster database to improve performance

library(RSQLite) #Library for the associated SQL functions
library(tm)
library(stringi)
source('Functions.R')


