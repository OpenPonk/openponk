tests
testAddAfterRender
	figure renderIn: view.
	figure add: (self newBox: 100 @ 20).

	self assert: figure background width equals: 100.
	self assert: figure background height equals: 20.
	self assert: figure figures size equals: 1