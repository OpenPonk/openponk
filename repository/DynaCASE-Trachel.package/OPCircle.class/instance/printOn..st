printing
printOn: aStream
	center printOn: aStream.
	aStream nextPutAll: ' radius: '.
	aStream nextPutAll: '(' , radius asString , ')'