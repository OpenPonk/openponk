interaction
deactivatePriority: aPositiveNumber
	(activations includesKey: aPositiveNumber)
		ifTrue: [ 
			activations removeKey: aPositiveNumber.
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
			self activationView update ]