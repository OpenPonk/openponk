private 
writeParameter: aParameter to: aStream
	aStream nextPutAll: aParameter name.
	aStream
		nextPutAll: ': ';
		nextPutAll: aParameter type.
	self writeMultiplicity: aParameter multiplicity to: aStream.
	aParameter defaultValue isNil
		ifFalse: [ 
			aStream
				nextPutAll: ' = ';
				nextPutAll: aParameter defaultValue ]