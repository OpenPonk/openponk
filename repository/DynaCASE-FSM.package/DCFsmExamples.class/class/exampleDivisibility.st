examples
exampleDivisibility
	| project fsm initial zero one two |
	project := DCProject named: 'FSM Example'.
	fsm := DCFsm named: 'Divisibility By Three'.
	project addDiagram: fsm.
	initial := DCFsmInitialState new.
	zero := DCFsmState named: '%3=0'.
	zero beFinal.
	one := DCFsmState named: '%3=1'.
	two := DCFsmState named: '%3=2'.
	fsm
		add: initial;
		add: zero;
		add: one;
		add: two.

	fsm
		addAll:
			{(initial -> zero).
			(zero -> zero name: '0').
			(zero -> one name: '1').
			(one -> zero name: '1').
			(one -> two name: '0').
			(two -> one name: '0').
			(two -> two name: '1')}.

	DCWorkbench openProject: project