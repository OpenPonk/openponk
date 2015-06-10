tests
testRemoveAll
	figure add: (self newBox: 150 @ 30).
	figure add: (self newBox: 100 @ 20).
	figure renderIn: view.
	figure remove: figure figures first.
	figure remove: figure figures first.

	self assert: figure background view isNil