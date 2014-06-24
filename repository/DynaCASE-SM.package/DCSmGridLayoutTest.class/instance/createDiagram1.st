as yet unclassified
createDiagram1
	| stateMachine region initialState finalState stateA stateB trans1 trans2 trans3 trans4 |
	stateMachine := DCSmStateMachine new.
	region := DCSmRegion new.
	stateMachine addRegion: region.
	initialState := DCSmPseudostate kind: DCSmPseudostateKind initial.
	finalState := DCSmFinalState new.
	stateA := DCSmState new name: 'A'.
	stateB := DCSmState new name: 'B'.
	region
		addSubvertex: initialState;
		addSubvertex: finalState;
		addSubvertex: stateA;
		addSubvertex: stateB.
	trans1 := DCSmTransition from: initialState to: stateA.
	trans2 := DCSmTransition from: stateA to: stateB.
	trans3 := DCSmTransition from: stateB to: stateA.
	trans4 := DCSmTransition from: stateB to: finalState.
	region
		addTransition: trans1;
		addTransition: trans2;
		addTransition: trans3;
		addTransition: trans4.
	^ stateMachine