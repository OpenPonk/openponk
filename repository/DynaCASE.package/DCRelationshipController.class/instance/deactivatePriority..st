interaction
deactivatePriority: aPositiveNumber
	(activations includesKey: aPositiveNumber)
		ifTrue: [ 
			activations removeKey: aPositiveNumber.
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
			self view update ]