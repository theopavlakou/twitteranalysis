from dictionaryOfWords import DictionaryOfWords
dow = DictionaryOfWords()

dow.addToDictionary("theo")
dow.addToDictionary("think")
dow.addToDictionary("it")
dow.addToDictionary("theo")
dow.addToDictionary("thonk")
dow.addToDictionary("thorn")
dow.addToDictionary("thorn")
dow.addToDictionary("theo")
dow.addToDictionary("heo")

l = dow.getSortedListOfTuples()
print(l)
print("\n\n\n")
print(dow.getMostPopularWords(2))
