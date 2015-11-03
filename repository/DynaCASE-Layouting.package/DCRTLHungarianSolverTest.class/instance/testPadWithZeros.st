tests
testPadWithZeros
	matrix := self matrixFor: #(#(1 3)).
	expected := self matrixFor: #(#(1 3) #(0 0)).
	self assert: (solver padWithZeros: matrix) equals: expected