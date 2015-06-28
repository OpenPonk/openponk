as yet unclassified
testChildren
	self childrenFor: fsm equals: (Array with: initialState with: state with: finalState).
	self childrenFor: initialState equals: {firstTransition}.
	self childrenFor: state equals: {secondTransition}