tests
testAddTwo
	figure add: (self newBox: 100 @ 20).
	figure add: (self newBox: 150 @ 30).
	figure renderIn: view.

	self assert: figure background width equals: 150.
	self assert: figure background height equals: 50.
	self assert: figure figures size equals: 2