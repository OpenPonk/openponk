tests
testEmpty
	figure renderIn: view.

	self assert: figure background view isNil.
	self assert: figure figures isEmpty