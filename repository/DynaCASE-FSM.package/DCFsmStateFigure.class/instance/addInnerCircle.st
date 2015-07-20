adding
addInnerCircle
	self hasInnerCircle
		ifTrue: [ ^ self ].
	self add: self newInnerCircle