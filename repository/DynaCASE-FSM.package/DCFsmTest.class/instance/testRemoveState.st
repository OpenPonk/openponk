tests
testRemoveState
	| d first second t |
	d := DCFsm new.
	first := DCFsmState new name: '1'.
	second := DCFsmState new name: '2'.
	t := DCFsmTransition from: first to: second.
	
	d
		add: first;
		add: second;
		add: t.
	self assert: d elements size = 3.
	
	d remove: first.
	self assert: d elements size = 1.
	self assert: first outgoing isEmpty.
	self assert: second incoming isEmpty