tests
testVector
	self assert: lineX vector = (100 @ 0).
	self assert: lineY vector = (0 @ 100).
	self assert: lineDiagonal vector = (-100 @ -100)