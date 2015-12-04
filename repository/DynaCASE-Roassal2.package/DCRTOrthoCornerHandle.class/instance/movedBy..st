positioning
movedBy: aVector
	positionLink value: positionLink value + aVector.
	self previous
		ifNotNil: [ :n | n moveBy: (self constraintVector: aVector for: n) from: self ].
	self next
		ifNotNil: [ :n | n moveBy: (self constraintVector: aVector for: n) from: self ].
	self removeIfNecessary