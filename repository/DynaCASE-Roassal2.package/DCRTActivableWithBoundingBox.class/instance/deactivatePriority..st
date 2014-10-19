interaction
deactivatePriority: aPositiveNumber
	(self unregisterPriority: aPositiveNumber)
		ifTrue: [ 
			activationElement shape borderColor: self topValue.
			activationElement update.
			activationElement view signalUpdate ]