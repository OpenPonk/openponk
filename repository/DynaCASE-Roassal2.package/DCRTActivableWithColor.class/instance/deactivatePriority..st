interaction
deactivatePriority: aPositiveNumber
	(self unregisterPriority: aPositiveNumber) & originElement view notNil
		ifTrue: [ 
			originElement shape color: self topValue.
			originElement update.
			originElement view signalUpdate ]