as yet unclassified
movedBy: aVector
	self basicMoveBy: aVector.
	self hasPredecessor
		ifTrue: [ self previous
				moveBy: (self constraintVector: aVector for: self previous)
				from: self ].
	self hasSuccessor
		ifTrue: [ self next moveBy: (self constraintVector: aVector for: self next) from: self ]