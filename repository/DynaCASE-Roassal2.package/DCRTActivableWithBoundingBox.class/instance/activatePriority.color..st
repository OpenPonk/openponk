interaction
activatePriority: aPositiveNumber color: aColor
	self registerPriority: aPositiveNumber color: aColor.
	activationElement view ifNil: [ originElement view add: activationElement ].
	activationElement shape borderColor: self topColor.
	activationElement update.
	activationElement view signalUpdate