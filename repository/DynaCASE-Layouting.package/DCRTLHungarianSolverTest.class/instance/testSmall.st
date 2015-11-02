tests
testSmall
	matrix := self
		matrixFor:
			{#(1 2 5).
			#(6 4 9).
			#(3 7 8)}.
	expected := {(#(1 3) -> 5).
	(#(2 2) -> 4).
	(#(3 1) -> 3)}.
	self assert: (solver solve: matrix) equals: expected