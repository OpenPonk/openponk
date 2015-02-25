accessing
bottom
	^ from y < to y
		ifTrue: [ from ]
		ifFalse: [ to ]