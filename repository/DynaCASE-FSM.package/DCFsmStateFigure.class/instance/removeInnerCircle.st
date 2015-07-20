removing
removeInnerCircle
	self hasInnerCircle
		ifFalse: [ ^ self ].
	self remove: self innerCircle