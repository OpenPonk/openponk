tests
testAddLine
	| lbl |
	figure addLine: 'new line'.
	figure renderIn: view.

	self assert: figure figures size equals: 1.
	lbl := figure figures first.
	self assert: (lbl isKindOf: RTElement).
	self assert: (lbl shape isKindOf: RTLabel).
	self assert: lbl model equals: 'new line'