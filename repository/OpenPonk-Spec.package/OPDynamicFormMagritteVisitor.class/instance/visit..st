visiting
visit: anObject
	anObject isVisible
		ifFalse: [ ^ self ].
	anObject acceptMagritte: self