tests
testMedium
	matrix := self
		matrixFor:
			{#(1 2 3 4).
			#(2 4 6 8).
			#(3 6 9 12).
			#(4 8 12 16)}.
	expected := {(#(1 4) -> 4).
	(#(2 3) -> 6).
	(#(3 2) -> 6).
	(#(4 1) -> 4)}.
	self assert: (solver solve: matrix) equals: expected