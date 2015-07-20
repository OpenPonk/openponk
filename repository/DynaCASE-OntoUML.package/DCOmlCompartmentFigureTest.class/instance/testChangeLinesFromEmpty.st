tests
testChangeLinesFromEmpty
	figure
		changeLines:
			'one
two'.
	figure renderIn: view.

	self assert: figure figures size equals: 2.
	self assert: figure figures first model equals: 'one'.
	self assert: figure figures second model equals: 'two'