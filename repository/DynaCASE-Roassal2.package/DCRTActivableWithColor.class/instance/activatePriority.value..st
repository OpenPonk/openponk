interaction
activatePriority: aPositiveNumber value: aColor
	self registerPriority: aPositiveNumber value: aColor.
	originElement shape color: self topValue.
	originElement update.
	originElement view signalUpdate