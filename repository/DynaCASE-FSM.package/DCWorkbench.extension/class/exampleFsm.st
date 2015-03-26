*DynaCASE-FSM
exampleFsm
	<example:'DynaCASE example FSM'>
	| project fsm initial first second final t1 t2 t3 t4 |
	project := DCProject new projectName: 'Example FSM'.
	fsm := DCFsm new name: 'FSM Diagram'.
	project addDiagram: fsm.
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
	(t2 := DCFsmTransition from: first to: second) name: 'a'.
	(t3 := DCFsmTransition from: second to: first) name: 'b'.
	(t4 := DCFsmTransition from: second to: final) name: 'a'.
	fsm
		add: t1;
		add: t2;
		add: t3;
		add: t4.
	^ self openProject: project