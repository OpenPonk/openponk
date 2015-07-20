as yet unclassified
setUp
	diagram := DCFsm named: 'Diagram'.
	initial := DCFsmInitialState named: 'initial'.
	(final := DCFsmState named: 'final') beFinal.
	state := DCFsmState named: 'state'.
	firstTransition := DCFsmTransition from: initial to: state named: 'first'.
	secondTransition := DCFsmTransition from: state to: final named: 'second'.
	selfTransition := DCFsmTransition from: state to: state named: 'self'