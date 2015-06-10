tests
testRemove
	figure add: (self newBox: 150 @ 30).
	figure add: (self newBox: 100 @ 20).
	figure renderIn: view.
	figure remove: figure figures first.

	self assert: figure background width equals: 100.
	self assert: figure background height equals: 20.
	self assert: figure figures size equals: 1