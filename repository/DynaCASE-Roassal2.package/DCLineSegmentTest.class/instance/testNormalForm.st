tests
testNormalForm
	self assert: lineX a = 0.
	self assert: lineY a = 100.
	self assert: lineDiagonal a = -100.
	self assert: lineX b = -100.
	self assert: lineY b = 0.
	self assert: lineDiagonal b = 100.
	self assert: lineX c = -1000.
	self assert: lineY c = -1000.
	self assert: lineDiagonal c = 2000