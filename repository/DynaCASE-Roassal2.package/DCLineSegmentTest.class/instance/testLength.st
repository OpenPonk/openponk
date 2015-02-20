tests
testLength
	self assert: lineX length = 100.
	self assert: lineY length = 100.
	self assert: (lineDiagonal length closeTo: 141.4213562)