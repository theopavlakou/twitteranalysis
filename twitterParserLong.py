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

filePrefix = "xa"
fileSuffix = "a"
print("File suffix is: " + fileSuffix) 

# Make a decoder to decode the JSON string
decoder = json.JSONDecoder()
# One dictionary of words for this whole script will store the bag of words
dictOfWords = DictionaryOfWords()

fileNumber = 0
while fileNumber < 10:
  print("--- Loading Tweets from file " + str(fileNumber) + ": " + filePrefix + fileSuffix + " ---")
  tweetSet = []
  jsonFile = open('/Users/theopavlakou/Documents/Imperial/Fourth_Year/MEng_Project/TWITTER Research/Data (100k tweets from London)/twitteranalysis/' + filePrefix + fileSuffix, 'r')
  # Files are of the form 'xa' + <suffix>. The suffix is incremented every time.
  fileSuffix = chr(ord(fileSuffix) + 1)
  fileNumber += 1

  try:
    # Remove first line as usually is not valid
    line = jsonFile.readline()
  except:
    pass
  maxLines = 0
  while maxLines < 100000:
	  try:
	    # Get all lines in the file
	    line = jsonFile.readline()
	    maxLines = maxLines+1
	    #print(str(maxLines) + chr(ord(fileSuffix)-1), " " )
      
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
      print("UnicodeDecodeError")
	    pass
	  except:
      print("Something bad happened")
	    pass
  print("--- Finished loading Tweets ---")
	
  print("--- Printing size of Tweets ---")
	# Print the number of tweets  
  print("    Size: " + str(len(tweetSet)))
	
  print("--- Loading words from the Tweets ---")
  for tweet in tweetSet:
    dictOfWords.addFromSet(tweet.listOfWords())
  print("--- Finished loading words from the Tweets ---")
	
# Make a file that has the words that are indexed by the columns of the matrix with their index to the left.
print("--- Opening file to output index of words to ---")
wordsFile = open("commonWordsIndex", "w")
# Matlab starts indexing from 1
i = 1 
listOfWords = dictOfWords.getMostPopularWordsAndOccurrences(3000)
for (word, occurrence) in listOfWords:
  wordsFile.write(str(i) + " " + word + " " + str(occurrence) + "\n")
  i = i + 1
print("--- Closing file to output index of words to ---")

# Now we have the bag of words. We must now go through the tweets a second time
# to build the matrix.
fileSuffix = "a"
fileNumber = 0
print("------ BUILDING MATRIX ------")
# Make a matrix of size (len(tweetSet)+1)x(len(setOfWords)+1). The first row will have the words and the first column will have the tweets (NOT the zeroth).
while fileNumber < 10:
  print("--- Loading Tweets from file " + str(fileNumber) + ": " + filePrefix + fileSuffix + " ---")
  tweetSet = []
  jsonFile = open('/Users/theopavlakou/Documents/Imperial/Fourth_Year/MEng_Project/TWITTER Research/Data (100k tweets from London)/twitteranalysis/' + filePrefix + fileSuffix, 'r')
  # Files are of the form 'xa' + <suffix>. The suffix is incremented every time.
  fileSuffix = chr(ord(fileSuffix) + 1)
  fileNumber += 1

  try:
    # Remove first line as usually is not valid
    line = jsonFile.readline()
  except:
    pass
  maxLines = 0
  while maxLines < 100000:
	  try:
	    # Get all lines in the file
	    line = jsonFile.readline()
	    maxLines = maxLines+1
	    #print(str(maxLines) + chr(ord(fileSuffix)-1), " " )
      
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
	
	# For each tweet, find the index of the words that correspond to the words in the tweet.
	# Put 1's in the matrix where the word appears and 0's where the word doesn't appear.
	# Print to an output file as a .csv
  print("--- Opening file to output result to ---")
  fileOut = open("S"+fileSuffix, "w")
  print("--- Printing matrix to file ---")
  for tweet in tweetSet:
    tweetWordList = tweet.listOfWords()
    # Check for each word in the list of unique words, which ones are in the tweet content and print a "1" if the particular word is and a "0" if not. 
    for i in range(len(listOfWords)):
      if listOfWords[i][0] in tweetWordList:
        fileOut.write("1,")
      else:
        fileOut.write("0,")
    # Next row
    fileOut.write("\n")
  print("--- Finished printing matrix to file ---")
  print("--- Closing file to output result to ---")
  fileOut.close()

wordsFile.close()
print("--- End ---")
