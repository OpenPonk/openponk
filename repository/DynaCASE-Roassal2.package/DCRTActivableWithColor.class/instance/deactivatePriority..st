interaction
deactivatePriority: aPositiveNumber
	(self unregisterPriority: aPositiveNumber)
		ifTrue: [ 
			originElement shape color: self topColor.
			originElement update.
			originElement view signalUpdate ]