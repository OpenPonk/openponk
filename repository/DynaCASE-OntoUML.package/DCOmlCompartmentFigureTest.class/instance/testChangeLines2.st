tests
testChangeLines2
	figure addLine: 'new line'.
	figure addLine: 'second line'.
	figure renderIn: view.
	figure
		changeLines:
			'altered first
altered second
added third'.

	self assert: figure figures size equals: 3.
	self assert: figure figures first model equals: 'altered first'.
	self assert: figure figures second model equals: 'altered second'.
	self assert: figure figures third model equals: 'added third'