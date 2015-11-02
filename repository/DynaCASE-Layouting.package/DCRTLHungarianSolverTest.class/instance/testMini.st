tests
testMini
	matrix := self
		matrixFor:
			{#(1 3).
			#(5 9)}.
	expected := {(#(1 2) -> 3).
	(#(2 1) -> 5)}.
	self assert: (solver solve: matrix) equals: expected