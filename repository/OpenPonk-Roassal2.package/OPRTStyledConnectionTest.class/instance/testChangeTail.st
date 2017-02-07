tests
testChangeTail
	edge := OPRTStyledConnection new edgeFrom: from to: to.
	view add: edge.
	self assert: edge shape tail shape equals: RTNoDecorationShape.
	self
		assert: edge trachelShape shapes last class
		equals: RTNoDecorationShape trachelShapeClass.

	edge shape tail: RTSimpleArrow asTail.
	edge update.
	self assert: edge shape tail shape equals: RTSimpleArrow.
	self assert: edge trachelShape shapes last class equals: RTSimpleArrow trachelShapeClass