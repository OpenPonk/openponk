private 
writeAttribute: anAttribute to: aStream
	self writeName: anAttribute name withFeatures: anAttribute features to: aStream.
	aStream
		nextPutAll: ': ';
		nextPutAll: anAttribute type.
	self writeMultiplicity: anAttribute multiplicity to: aStream.
	anAttribute defaultValue isNil
		ifFalse: [ 
			aStream
				nextPutAll: ' = ';
				nextPutAll: anAttribute defaultValue ]