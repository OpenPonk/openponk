interaction
activatePriority: aPositiveNumber value: aColor
	activations add: (Association key: aPositiveNumber value: aColor).
	self activationView shape
		borderColor:
			(activations
				at:
					(activations keys
						inject: 0
						into: [ :max :key | 
							key > max
								ifTrue: [ key ]
								ifFalse: [ max ] ])).
	self activationView update