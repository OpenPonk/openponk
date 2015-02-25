tests
testIntersectVertical
	self assert: (lineY intersectVertical: lineX0) = (lineY intersection: lineX0).
	self assert: (lineY intersectVertical: lineX) = (lineY intersection: lineX).
	self assert: (lineY intersectVertical: lineDiagonal) = (lineY intersection: lineDiagonal).
	self assert: (lineY intersectVertical: lineY) = (lineY intersection: lineY)