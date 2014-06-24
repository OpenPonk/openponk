as yet unclassified
selectFinalStates: statesCollection
	^ statesCollection select: [ :state | state isMemberOf: DCSmFinalState ]