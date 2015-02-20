tests
testIntersection
	self assert: (lineX intersection: lineY) = (10 @ -10).
	self assert: (lineX intersection: lineDiagonal) = (10 @ -10).
	self assert: (lineY intersection: lineDiagonal) = (10 @ -10).
	self assert: (lineX intersection: lineX0) isNil.
	self assert: (lineY intersection: lineX0) = (10 @ 0).
	self assert: (lineDiagonal intersection: lineX0) isNil