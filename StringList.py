
import math
class StringList:
  """ A class that represents a list of strings. Specifically a list of strings that are sorted alphabetically. It also has methods for searching the list."""

  def __init__(self, listOfStrings):
    """ Initialised with a list of strings, sorted in alphabetical order. """
    self.strings = listOfStrings
  
  def compareStrings(self, stringOne, stringTwo):
    # TODO
    # Must fix the repetition of code
    """ Will return 1 if stringOne should come first alphabetically, -1 if stringTwo should come first and 0 if they are equal."""
    # By default stringOne will come first
    if (len(stringOne) < len(stringTwo)):
      # For every letter in stringOne
      for i in range(len(stringOne)):
        valueOne = ord(stringOne[i])
        valueTwo = ord(stringTwo[i])
        if (valueOne > valueTwo):
          return -1
        elif (valueOne < valueTwo):
          return 1
      # If we exit the for loop and haven't returned yet, it either means that stringOne comes first as we know that stringTwo is longer than stringOne. Possible scenario: stringOne = "the" and stringTwo = "these".
      return 1
    else:
      # For every letter in stringOne
      for i in range(len(stringTwo)):
        valueOne = ord(stringOne[i])
        valueTwo = ord(stringTwo[i])
        if (valueOne > valueTwo):
          return -1
        elif (valueOne < valueTwo):
          return 1
      if(len(stringOne) > len(stringTwo)):
        return 1
      else:
        return 0

  def stringInList(self,stringToFind):
    """ Binary search the sorted list of strings to find the word that is necessary to find. Returns True if in list and false if not. """
    if len(self.strings) == 0:
      return False
    length = len(self.strings)
    max = len(self.strings) - 1
    min = 0
    while (max - min) > 1:
      midpoint = math.ceil((max+min)/2)
      comparison = self.compareStrings(stringToFind, self.strings[midpoint]) 
      if comparison == 0:
        return True
      elif comparison == -1:
        # It is on the right of the midpoint
        min = midpoint
      elif comparison == 1:
        # It is on the left of the midpoint
        max = midpoint
    if max < len(self.strings): 
      comparison1 = self.compareStrings(stringToFind, self.strings[max]) 
    comparison2 = self.compareStrings(stringToFind, self.strings[min]) 
    if(comparison1 == 0 or comparison2 == 0):
      return True
    return False
