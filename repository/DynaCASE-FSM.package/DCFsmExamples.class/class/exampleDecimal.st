examples
exampleDecimal
	| project fsm initial z b c d k isDigit |
	project := DCProject named: 'FSM Example'.
	fsm := DCFsm named: 'Decimal number'.
	project addDiagram: fsm.
	initial := DCFsmInitialState new.
	z := DCFsmState named: 'Z'.
	b := DCFsmState named: 'B'.
	(c := DCFsmState named: 'C') beFinal.
	d := DCFsmState named: 'D'.
	(k := DCFsmState named: 'K') beFinal.
	fsm
		add: initial;
		add: z;
		add: b;
		add: c;
		add: d;
		add: k.

	fsm
		addAll:
			{(initial -> z).
			(z -> b name: '+').
			(z -> b name: '-').
			(z -> c name: 'd').
			(z -> d name: '.').
			(b -> c name: 'd').
			(c -> d name: '.').
			(c -> c name: 'd').
			(b -> d name: '.').
			(d -> k name: 'd').
			(k -> k name: 'd')}.

	isDigit := [ :aValue | '^[0-9]$' asRegex matches: aValue ].
	fsm transitions select: [ :each | each name = 'd' ] thenDo: [ :each | each matchBlock: isDigit ].

	DCWorkbench openProject: project