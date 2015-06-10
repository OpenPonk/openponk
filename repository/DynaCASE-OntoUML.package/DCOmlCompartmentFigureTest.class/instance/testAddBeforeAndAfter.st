tests
testAddBeforeAndAfter
	figure add: (self newBox: 150 @ 30).
	figure renderIn: view.
	figure add: (self newBox: 100 @ 20).

	self assert: figure background width equals: 150.
	self assert: figure background height equals: 50.
	self assert: figure figures size equals: 2