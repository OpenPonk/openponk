tests
testEmpty
	figure renderIn: view.

	self assert: figure figures size equals: 3.
	self assert: figure background height equals: figure minSize y.
	self assert: figure background width equals: figure minSize x