positioning
movedBy: aVector
	self previous moveBy: (self constraintVector: aVector for: self previous) from: self.
	self next moveBy: (self constraintVector: aVector for: self next) from: self.
	positionLink value: element position