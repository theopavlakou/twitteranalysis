import json
from Tweet import Tweet

class TweetRetriever:
  """ A class that retrieves Tweets from the file name specified. It retrieves tweets in a rolling windo fashion. The window size is specified and so is the incrementing batch size."""
  
  def __init__(self, nameFileOfTweets, windowSize, batchSize):
    self.nameFileOfTweets = nameFileOfTweets
    self.windowSize = windowSize
    self.batchSize = batchSize
    self.currentTweets = []
    self.currentOffset = 0
    
  def initialise(self):
    """ Must be called before anything else. """
    self.jsonFile = open(self.nameFileOfTweets, 'r')
    self.decoder = json.JSONDecoder()
    self.jsonFile.seek(self.currentOffset)
    
  def getNextWindow(self):
    """ Retrieves the next window of Tweets. """
    # If empty then we have not yet got any Tweets
    toLoad = 0
    if len(self.currentTweets) == 0:
      toLoad = self.windowSize
    else:
      toLoad = self.batchSize

    # Make a decoder to decode the JSON string
    numberConsecutivePasses = 0
    loaded = 0

    self.jsonFile.seek(self.currentOffset)
    while (numberConsecutivePasses < 100 and loaded < toLoad):
      try:
        # Get all lines in the file
        line = self.jsonFile.readline()
        self.currentOffset += len(line)
        # The lines will contain a non-empty string until the eof
        # so we can break the loop when this happens
        if line == "":
          print("Broke out of loop")
          break  
        # Translate the JSON string into python JSON representation
        jsonObject = self.decoder.decode(line)
        tweet = Tweet(jsonObject["text"])
        # If we have more than the window size then pop the oldest off
        if len(self.currentTweets) == self.windowSize:
          prevTweet = self.currentTweets.pop(0)

        self.currentTweets.append(tweet)
        loaded += 1
        numberConsecutivePasses = 0
      # Some of the lines have encoding errors so ignore them  
      except UnicodeDecodeError:
        numberConsecutivePasses += 1
        pass
      except:
        numberConsecutivePasses += 1
        pass
    return self.currentTweets 
