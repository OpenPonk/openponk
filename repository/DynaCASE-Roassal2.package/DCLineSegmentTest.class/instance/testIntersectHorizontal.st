tests
testIntersectHorizontal
	"assumes intersection: method is tested elsewhere"

	self assert: (lineY intersectHorizontal: lineX) = (lineY intersection: lineX).
	self assert: (lineY intersectHorizontal: lineX0) = (lineY intersection: lineX0).
	self assert: (lineDiagonal intersectHorizontal: lineX) = (lineDiagonal intersection: lineX).
	self assert: (lineDiagonal intersectHorizontal: lineX0) = (lineDiagonal intersection: lineX0).
	self assert: (lineX intersectHorizontal: lineX0) = (lineX intersection: lineX0).
	self assert: (lineX intersectHorizontal: lineX) = (lineX intersection: lineX)