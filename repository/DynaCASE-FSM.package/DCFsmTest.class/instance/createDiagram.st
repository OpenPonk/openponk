as yet unclassified
createDiagram
	| fsm initial first second final t1 t2 t3 t4 |
	fsm := DCFsm new.
	initial := DCFsmInitialState new.
	first := DCFsmState new name: '1'.
	second := DCFsmState new name: '2'.
	final := DCFsmFinalState new name: '3'.
	fsm
		add: initial;
		add: first;
		add: second;
		add: final.
	t1 := DCFsmTransition from: initial to: first.
	t2 := DCFsmTransition from: first to: second.
	t3 := DCFsmTransition from: second to: first.
	t4 := DCFsmTransition from: second to: final.
	fsm
		add: t1;
		add: t2;
		add: t3;
		add: t4.
	^ fsm