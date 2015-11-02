printing
printOn: aStream
	aStream
		nextPutAll: self from label;
		nextPutAll: '->';
		nextPutAll: self to label