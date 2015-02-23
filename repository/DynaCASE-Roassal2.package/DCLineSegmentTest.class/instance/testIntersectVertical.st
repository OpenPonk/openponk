tests
testIntersectVertical
	self assert: (lineX0 intersectVertical: lineY) = (lineX0 intersection: lineY).
	self assert: (lineX intersectVertical: lineY) = (lineX intersection: lineY).
	self assert: (lineDiagonal intersectVertical: lineY) = (lineDiagonal intersection: lineY).
	self assert: (lineY intersectVertical: lineY) = (lineY intersection: lineY)