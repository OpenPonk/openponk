tests
testAdd
	| d first second t |
	d := DCFsm new.
	self assert: d elements size = 0.

	first := DCFsmState new name: '1'.
	d add: first.
	second := DCFsmState new name: '2'.
	d add: second.
	self assert: d elements size = 2.
	self assert: d elements first owner = d.

	t := DCFsmTransition from: d elements first to: d elements second.
	d add: t.
	self assert: d elements size = 3.
	self assert: d elements third owner = d.