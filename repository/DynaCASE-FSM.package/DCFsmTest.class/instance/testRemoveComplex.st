tests
testRemoveComplex
	| diagram initial first second final t1 t2 t3 t4 |
	diagram := DCFsm new.

	initial := DCFsmInitialState new.
	first := DCFsmState new name: '1'.
	second := DCFsmState new name: '2'.
	final := DCFsmFinalState new name: '3'.
	diagram
		add: initial;
		add: first;
		add: second;
		add: final.

	t1 := DCFsmTransition from: initial to: first.
	(t2 := DCFsmTransition from: first to: second) name: 'a'.
	(t3 := DCFsmTransition from: second to: first) name: 'b'.
	(t4 := DCFsmTransition from: second to: final) name: 'a'.
	diagram
		add: t1;
		add: t2;
		add: t3;
		add: t4.

	self assert: diagram elements size = 8.

	diagram remove: first.
	self assert: diagram elements size = 4.

	diagram
		remove: initial;
		remove: final.
	self assert: diagram elements size = 1