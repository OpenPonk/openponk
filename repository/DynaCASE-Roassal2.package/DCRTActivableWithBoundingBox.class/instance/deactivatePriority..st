interaction
deactivatePriority: aPositiveNumber
	(self unregisterPriority: aPositiveNumber)
		ifTrue: [ 
			activationElement shape borderColor: self topColor.
			activationElement update.
			activationElement view signalUpdate ]