tests
testPadWithZeros2
	matrix := self matrixFor: #(#(1) #(2)).
	expected := self matrixFor: #(#(1 0) #(2 0)).
	self assert: (solver padWithZeros: matrix) equals: expected