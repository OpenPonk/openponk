tests
testChangeHead
	edge := OPRTStyledConnection new edgeFrom: from to: to.
	view add: edge.
	self assert: edge shape head shape equals: RTNoDecorationShape.
	self
		assert: (edge trachelShape shapes atLast: 2) class
		equals: RTNoDecorationShape trachelShapeClass.

	edge shape head: RTSimpleArrow asHead.
	edge update.
	self assert: edge shape head shape equals: RTSimpleArrow.
	self
		assert: (edge trachelShape shapes atLast: 2) class
		equals: RTSimpleArrow trachelShapeClass