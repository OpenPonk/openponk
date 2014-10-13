interaction
deactivateLevel: aPositiveNumber
	activation removeKey: aPositiveNumber.
	self view shape
		color:
			(activation
				at:
					(activation keys
						inject: 0
						into: [ :max :key | 
							key > max
								ifTrue: [ key ]
								ifFalse: [ max ] ])).
	self view update