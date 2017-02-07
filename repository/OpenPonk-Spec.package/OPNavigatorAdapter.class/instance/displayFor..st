widget API
displayFor: anObject
	^ (self mappingFor: anObject in: self retrieveDisplayMapping)
		ifNotNil: [ :suffix | anObject name , (suffix ifNotEmpty: [ ' (' , suffix , ')' ]) ]