interaction
activateLevel: aPositiveNumber color: aColor
	activation add: (Association key: aPositiveNumber value: aColor).
	self activationView shape
		borderColor:
			(activation
				at:
					(activation keys
						inject: 0
						into: [ :max :key | 
							key > max
								ifTrue: [ key ]
								ifFalse: [ max ] ])).
	self activationView update