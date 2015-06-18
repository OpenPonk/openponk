tests
testWithSpacing
	figure padding: 5 @ 15.
	figure layout verticalGap: 10.
	figure add: (self newBox: 100 @ 20).
	figure add: (self newBox: 150 @ 50).
	figure renderIn: view.

	self assert: figure background width equals: 5 + 150 + 5.
	self assert: figure background height equals: 15 + 20 + 10 + 50 + 15