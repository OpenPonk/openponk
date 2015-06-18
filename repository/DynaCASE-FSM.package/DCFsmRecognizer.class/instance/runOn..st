public - running
runOn: aString
	input := aString asOrderedCollection.
	remainder := aString asOrderedCollection.
	completed := false.
	accepts := nil.
	self start