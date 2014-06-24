as yet unclassified
selectInitialStates: statesCollection
	^ (self selectPseudostates: statesCollection) select: [ :state | state kind = DCSmPseudostateKind initial ]