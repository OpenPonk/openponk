layouting
layoutOn: elements
	self hasInnerCircle
		ifFalse: [ ^ self ].
	self innerCircle translateTo: self background position