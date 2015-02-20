tests
testIntersectLines
	self assert: (lineX intersectLines: lineY) = (10 @ -10).
	self assert: (lineX intersectLines: lineDiagonal) = (10 @ -10).
	self assert: (lineY intersectLines: lineDiagonal) = (10 @ -10).
	self assert: (lineX intersectLines: lineX0) isNil.
	self assert: (lineY intersectLines: lineX0) = (10 @ 0).
	self assert: (lineDiagonal intersectLines: lineX0) = (20 @ 0)