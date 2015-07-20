as yet unclassified
testDisplay
	self displayFor: fsm equals: fsm name , ' (Diagram)'.
	self displayFor: initialState equals: initialState name , ' (Initial State)'.
	self displayFor: state equals: state name , ' (State)'.
	self displayFor: finalState equals: finalState name , ' (Final State)'.
	self displayFor: firstTransition equals: firstTransition name , ' (Transition)'