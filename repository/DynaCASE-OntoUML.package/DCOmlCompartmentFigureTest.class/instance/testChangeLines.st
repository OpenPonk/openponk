tests
testChangeLines
	figure addLine: 'new line'.
	figure addLine: 'second line'.
	figure renderIn: view.
	figure changeLines: 'altered first'.

	self assert: figure figures size equals: 1.
	self assert: figure figures first model equals: 'altered first'