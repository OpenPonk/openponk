interaction
activatePriority: aPositiveNumber color: aColor
	self registerPriority: aPositiveNumber color: aColor.
	originElement shape color: self topColor.
	originElement update.
	originElement view signalUpdate