## A parser for the twitter data file with all the JSON data. Reads in the JSON data and prints out a matrix of the form:
## 0,       word1,  word2,  word3,  ...,  wordn
## tweet1,  0,      1,      1,      ...,  0
## tweet2,  1,      1,      0,      ...,  0
## ...,     ...,    ...,    ...,    ...,  ...
## tweetm,  0,      1,      0,      ...,  0
## where n is the number of unique and relevant words in the whole set of Tweets and m is the number of Tweets that are successfully extracted from the data.
## There are 1's whenever the word of a particular column appears in the Tweet of a particular row, else there is a 0.
## This file can then be used for Sparse PCA.

import json
from bagOfWords import BagOfWords
from dictionaryOfWords import DictionaryOfWords
from Tweet import Tweet

# To test, uncomment the next two lines
#jsonFile = open('/Users/theopavlakou/Documents/Imperial/Fourth_Year/MEng_Project/TWITTER Research/Data (100k tweets from London)/twitterdataanalysis/testJsons', 'r')
#commonWordsFile = open('/Users/theopavlakou/Documents/Imperial/Fourth_Year/MEng_Project/TWITTER Research/Data (100k tweets from London)/twitterdataanalysis/commonWords', 'r')
#jsonFile = open('/Users/theopavlakou/Documents/Imperial/Fourth_Year/MEng_Project/TWITTER Research/Data (100k tweets from London)/twitterdataanalysis/London_100k_tweets_short', 'r')
jsonFile = open('/Users/theopavlakou/Documents/Imperial/Fourth_Year/MEng_Project/TWITTER Research/Data (100k tweets from London)/twitterdataanalysis/Twitter_Data_1000.txt', 'r')

#commonWordsFile = open('/Users/theopavlakou/Documents/Imperial/Fourth_Year/MEng_Project/TWITTER Research/Data (100k tweets from London)/twitterdataanalysis/CommonWordsPlain.txt', 'r')

# Here we are loading the common words from the text file that contains all the common words in it.
#print("--- Loading common words ---")
#listOfWords = []
#while True:
#  try:
#    line = commonWordsFile.readline()
#    # If we have reached the end of the file, break the loop
#    if line == "":
#      break
#    # If we don't have just a space, then take the word
#    if line != " ":
#      listOfWords.append(line.strip())
#  except:
#    pass
#for word in listOfWords:
  #print(word)
#print("--- Finished loading common words ---")


print("--- Loading Tweets ---")
tweetSet = []
# Make a decoder to decode the JSON string
decoder = json.JSONDecoder()

while True:
  try:
    # Get all lines in the file
    line = jsonFile.readline()
    # The lines will contain a non-empty string until the eof
    # so we can break the loop when this happens
    if line == "":
      break  
    # Translate the JSON string into python JSON representation
    jsonObject = decoder.decode(line)
    # Make a new tweet and add it to the set of tweets that we have
    # TODO
    # For some reason this doesn't work when I add the date. Must fix.
    #tweet = Tweet(jsonObject["text"], jsonObject["created_at"])
    tweet = Tweet(jsonObject["text"])
    # print("Tweet content is " + tweet.content + ", and it was created on " + "NOT TODAY")
    tweetSet.append(tweet)
  # Some of the lines have encoding errors so ignore them  
  except UnicodeDecodeError:
    pass
  except:
    pass
print("--- Finished loading Tweets ---")

print("--- Printing size of Tweets ---")
# Print the number of tweets  
print("    Size: " + str(len(tweetSet)))

print("--- Loading most probable common words in the Tweets ---")
# Make a list of all the unique words in the tweets which will be the columns of the matrix. 
# Should reduce the > 75,000 words we have by about a factor of 10
#bagOfWords = BagOfWords(0.015)
dictOfWords = DictionaryOfWords()

for tweet in tweetSet:
  dictOfWords.addFromSet(tweet.listOfWords())
  #bagOfWords.addFromSetWithProbability(tweet.listOfWords())
#listOfWords = bagOfWords.getListOfWords()
listOfWords = dictOfWords.getMostPopularWords(2500)

print("--- Finished loading most probable common words in the Tweets ---")

print("--- Printing number of unique and relevant words ---")
print("    Size: " + str(len(listOfWords)))
print("--- Finished printing number of unique and relevant words ---")
# Make a matrix of size (len(tweetSet)+1)x(len(setOfWords)+1). The first row will have the words and the first column will have the tweets (NOT the zeroth).
print("--- Opening file to output result to ---")
fileOut = open("M2", "w")

# Make a file that has the words that are indexed by the columns of the matrix with their index to the left.
print("--- Opening file to output index of words to ---")
wordsFile = open("commonWordsIndex", "w")
# Matlab starts indexing from 1
i = 1 
for word in listOfWords:
  wordsFile.write(str(i) + " " + word+ "\n")
  i = i + 1
print("--- Closing file to output index of words to ---")
wordsFile.close()

# Make a file that has the tweet content of the tweets that are indexed by the rows of the matrix with their index to the left.
print("--- Opening file to output index of tweets to ---")
tweetsFile = open("tweetsIndex", "w")
# Matlab starts indexing from 1
i = 1
for tweet in tweetSet:
  tweetsFile.write(str(i) + " " + tweet.content + "\n")
  i = i + 1
print("--- Closing file to output index of tweets to ---")
tweetsFile.close()

# For each tweet, find the index of the words that correspond to the words in the tweet.
# Put 1's in the matrix where the word appears and 0's where the word doesn't appear.
# Print to an output file as a .csv
print("--- Printing matrix to file ---")
for tweet in tweetSet:
  # In the first column, always write the contents of the tweet
  tweetWordList = tweet.listOfWords()
  # Check for each word in the list of unique words, which ones are in the tweet content and print a "1" if the particular word is and a "0" if not. 
  for i in range(len(listOfWords)):
    if listOfWords[i] in tweetWordList:
      fileOut.write("1,")
    else:
      fileOut.write("0,")
  # Next row
  fileOut.write("\n")
print("--- Finished printing matrix to file ---")

print("--- Closing file to output result to ---")
fileOut.close()
print("--- End ---")
