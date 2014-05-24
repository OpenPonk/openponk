private 
writeMultiplicity: aMultiplicity to: aStream
	aStream nextPutAll: '['.
	aMultiplicity min == aMultiplicity max
		ifTrue: [ aStream nextPutAll: aMultiplicity min ]
		ifFalse: [ 
			aStream
				nextPutAll: aMultiplicity min;
				nextPutAll: '..';
				nextPutAll: aMultiplicity max ].
	aStream nextPutAll: ']'