interaction
deactivatePriority: aPositiveNumber
	(self unregisterPriority: aPositiveNumber)
		ifTrue: [ 
			originElement shape color: self topValue.
			originElement update.
			originElement view signalUpdate ]