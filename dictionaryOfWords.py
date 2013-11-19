class DictionaryOfWords:
  """ A class that represents a dictionary of words as keys and their occurrences as the value. """
  def __init__(self):
    self.dict = {}

  def addToDictionary(self, word):
    """ Add to dictionary with the occurence of the word. """
    if word in self.dict:
      self.dict[word] += 1
    else:
      self.dict[word] = 1

  def addFromSet(self, wordSet):
    """ Add words from a wordSet. """
    for word in wordSet:
      self.addToDictionary(word)

  def getSortedListOfTuples(self):
    """ Returns a sorted list of tuples of the form (keyValue, key). """ 
    listOfTuples = []
    for key in self.dict:
      listOfTuples.append((self.dict[key], key))
    return sorted(listOfTuples, reverse=True)

  def getMostPopularWords(self, limit):
    listOfTuples = self.getSortedListOfTuples()
    listToReturn = []
    x = 1
    for (value, key) in listOfTuples:
      if x <= limit:
        listToReturn.append(key)
        x += 1
      else:
        break
    return listToReturn

  def getMostPopularWordsAndOccurrences(self, limit):
    listOfTuples = self.getSortedListOfTuples()
    listToReturn = []
    x = 1
    for (value, key) in listOfTuples:
      if x <= limit:
        listToReturn.append((key, value))
        x += 1
      else:
        break
    return listToReturn
