as yet unclassified
selectSemiRegularStates: statesCollection
	"select nonfinal states and noninitial pseudostates"

	| pseudoStates nonFinalStates |
	pseudoStates := (self selectPseudostates: statesCollection)
		select: [ :state | state kind ~= DCSmPseudostateKind initial ].
	nonFinalStates := statesCollection select: [ :state | state isMemberOf: DCSmState ].
	^ pseudoStates , nonFinalStates