interaction
activatePriority: aPositiveNumber value: aValue
	self registerPriority: aPositiveNumber value: aValue.
	activationElement view ifNil: [ originElement view add: activationElement ].
	activationElement shape borderColor: self topValue.
	activationElement update.
	activationElement view signalUpdate