interaction
deactivateLevel: aPositiveNumber
	activation removeKey: aPositiveNumber.
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