private 
writeOperation: anOperation to: aStream
	| ret |
	self writeName: anOperation name withFeatures: anOperation features to: aStream.
	aStream nextPutAll: '('.
	self writeParameters: anOperation parameters to: aStream.
	aStream nextPutAll: ')'.
	ret := anOperation returnValue.
	ret notNil
		ifTrue: [ 
			aStream
				nextPutAll: ': ';
				nextPutAll: ret type.
			self writeMultiplicity: ret multiplicity to: aStream ]