widget API
displayFor: anObject
	^ (self mappingFor: anObject in: self retrieveDisplayMapping)
		ifNil: [ anObject printString ]
		ifNotNil: [ :suffix | anObject name , (suffix ifNotEmpty: [ ' (' , suffix , ')' ]) ]