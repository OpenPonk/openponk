private
topColor
	^ activations
		at:
			(activations keys
				inject: 0
				into: [ :max :key | 
					key > max
						ifTrue: [ key ]
						ifFalse: [ max ] ])