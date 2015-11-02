tests
testMicro
	matrix := self matrixFor: {#(1)}.
	expected := {(#(1 1) -> 1)}.
	self assert: (solver solve: matrix) equals: expected