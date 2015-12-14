as yet unclassified
printOn: aStream
	aStream nextPutAll: '{ '.
	self from printOn: aStream.
	aStream nextPutAll: ' -> '.
	self to printOn: aStream.
	aStream nextPutAll: ' }'