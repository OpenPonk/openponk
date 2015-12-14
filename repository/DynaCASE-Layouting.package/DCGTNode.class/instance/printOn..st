as yet unclassified
printOn: aStream
	aStream nextPutAll: 'N'.
	aStream nextPut: $(.
	self model printOn: aStream.
	aStream nextPut: $)