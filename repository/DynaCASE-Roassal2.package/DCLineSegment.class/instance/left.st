accessing
left
	^ from x < to x
		ifTrue: [ from ]
		ifFalse: [ to ]