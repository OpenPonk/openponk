as yet unclassified
setUp
	super setUp.
	fsm := DCFsm named: 'FSM'.
	initialState := DCFsmInitialState named: 'initial'.
	state := DCFsmState named: 'state'.
	finalState := DCFsmState named: 'final'.
	finalState beFinal.
	firstTransition := DCFsmTransition from: initialState to: state named: 'first'.
	secondTransition := DCFsmTransition from: state to: finalState named: 'second'.
	fsm
		add: initialState;
		add: state;
		add: finalState;
		add: firstTransition;
		add: secondTransition