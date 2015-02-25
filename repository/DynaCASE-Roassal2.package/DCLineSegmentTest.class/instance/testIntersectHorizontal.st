tests
testIntersectHorizontal
	"assumes intersection: method is tested elsewhere"

	self assert: (lineX intersectHorizontal: lineY) = (lineX intersection: lineY).
	self assert: (lineX0 intersectHorizontal: lineY) = (lineX0 intersection: lineY).
	self assert: (lineX intersectHorizontal: lineDiagonal) = (lineX intersection: lineDiagonal).
	self assert: (lineX0 intersectHorizontal: lineDiagonal) = (lineX0 intersection: lineDiagonal).
	self assert: (lineX0 intersectHorizontal: lineX) = (lineX0 intersection: lineX).
	self assert: (lineX intersectHorizontal: lineX) = (lineX intersection: lineX)