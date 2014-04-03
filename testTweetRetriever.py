from TweetRetriever import TweetRetriever

fileName = '/Users/theopavlakou/Documents/Imperial/Fourth_Year/MEng_Project/TWITTER Research/Data (100k tweets from London)/twitteranalysis/testJsons'
tr = TweetRetriever(fileName, 6, 4)
tr.initialise()

nextWindow = tr.getNextWindow()

print('-------- First Batch --------')
i = 0
for tweet in nextWindow:
  print('  Tweet ' + str(i)+":")
  for word in tweet.listOfWords():
    print("    " + word)
  i += 1

print('-------- Second Batch --------')
nextWindow = tr.getNextWindow()

i = 0
for tweet in nextWindow:
  print('  Tweet ' + str(i)+":")
  for word in tweet.listOfWords():
    print("    " + word)
  i += 1
 
print('-------- Third Batch --------')
nextWindow = tr.getNextWindow()

i = 0
for tweet in nextWindow:
  print('  Tweet ' + str(i)+":")
  for word in tweet.listOfWords():
    print("    " + word)
  i += 1
