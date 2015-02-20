tests
testAngles
	self assert: lineX angleInDeg = 0.
	self assert: lineY angleInDeg = 90.
	self assert: lineDiagonal angleInDeg = 225.
	self assert: lineX angleInRad = 0.
	self assert: (lineY angleInRad closeTo: 1.5707963268)