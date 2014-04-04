###########################################################################################################################
## A parser for the twitter data file with all the JSON data. Reads in the JSON data and prints out a matrix of the form:
## 0,       word1,  word2,  word3,  ...,  wordn
## tweet1,  0,      1,      1,      ...,  0
## tweet2,  1,      1,      0,      ...,  0
## ...,     ...,    ...,    ...,    ...,  ...
## tweetm,  0,      1,      0,      ...,  0
## where n is the number of unique and relevant words in the whole set of Tweets and m is the number of Tweets that are successfully extracted from the data.
## There are 1's whenever the word of a particular column appears in the Tweet of a particular row, else there is a 0.
## This file can then be used for Sparse PCA.
###########################################################################################################################

import json
from bagOfWords import BagOfWords
from dictionaryOfWords import DictionaryOfWords
from Tweet import Tweet
from TweetRetriever import TweetRetriever

####################################################
##  The file containing the Tweets as JSONs
####################################################
jsonFileName = '/Users/theopavlakou/Documents/Imperial/Fourth_Year/MEng_Project/TWITTER Research/Data (100k tweets from London)/twitteranalysis/xab'

####################################################
##  Load the Tweets from the file
####################################################
print("--- Loading Tweets ---")
# TODO Change this to be smaller than the actual file. 
sizeOfWindow = 60000
batchSize = 5000
tweetRetriever = TweetRetriever(jsonFileName, sizeOfWindow, batchSize)
tweetRetriever.initialise()
tweetSet = tweetRetriever.getNextWindow()
print("--- Finished loading Tweets ---")

####################################################
##  Print the number of Tweets there are 
####################################################
print("--- Printing size of Tweets ---")
print("    Size: " + str(len(tweetSet)))

########################################################
##  Make a list of the 3000 most common words in the 
##  Tweets which will be the columns of the matrix.
########################################################
print("--- Loading most common words in the Tweets ---")
dictOfWords = DictionaryOfWords()
for tweet in tweetSet:
  dictOfWords.addFromSet(tweet.listOfWords())
listOfWords = dictOfWords.getMostPopularWordsAndOccurrences(3000)
print("--- Finished loading most common words in the Tweets ---")

########################################################
##  Print the number of words in the bag-of-words. 
########################################################
print("--- Printing number of unique and relevant words ---")
print("    Size: " + str(len(listOfWords)))
print("--- Finished printing number of unique and relevant words ---")

########################################################
##  Open the file to output the sparse matrix 
##  representation to. 
########################################################
print("--- Opening file to output result to ---")
fileOut = open("S_xab", "w")

########################################################
##  Open the file to output the words with their index. 
########################################################
print("--- Opening file to output index of words to ---")
wordsFile = open("commonWordsIndex", "w")
# Matlab starts indexing from 1
i = 1 
for (word, occurrence) in listOfWords:
  wordsFile.write(str(i) + " " + word + " " + str(occurrence) + "\n")
  i = i + 1
print("--- Closing file to output index of words to ---")
wordsFile.close()

############################################################################################
# For each tweet, find the index of the words that correspond to the words in the tweet.
# This prints out to the file in the following format:
# 1, 5, 7, 8
# 2, 
# 3, 6
# which means that Tweet 1 contains words {5, 7, 8}, Tweet 2 contains no words in 
# the bag of words and Tweet 3 contains word {6}.
############################################################################################
print("--- Printing matrix to file ---")
# Matlab starting index is 1
j = 1
for tweet in tweetSet:
  # Get the list of words in the tweet
  tweetWordList = tweet.listOfWords()
  # The first number is the index of the tweet (the row number)
  fileOut.write(str(j) + ",")
  # Check for each word in the list of unique words, if it is in the Tweet, then print the index of the word 
  for i in range(len(listOfWords)):
    if listOfWords[i][0] in tweetWordList:
      fileOut.write(str(i+1) + ",")
  # Next row
  fileOut.write("\n")
  j = j + 1
print("--- Finished printing matrix to file ---")

print("--- Closing file to output result to ---")
fileOut.close()
print("--- End ---")
