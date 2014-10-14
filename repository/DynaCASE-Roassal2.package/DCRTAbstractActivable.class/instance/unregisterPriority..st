private
unregisterPriority: aPositiveNumber
	(activations includesKey: aPositiveNumber)
		ifTrue: [ 
			activations removeKey: aPositiveNumber.
			^ true ]
		ifFalse: [ ^ false ]