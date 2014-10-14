interaction
activatePriority: aPositiveNumber value: aColor
	activations add: (Association key: aPositiveNumber value: aColor).
	self view shape
		color:
			(activations
				at:
					(activations keys
						inject: 0
						into: [ :max :key | 
							key > max
								ifTrue: [ key ]
								ifFalse: [ max ] ])).
	self view update