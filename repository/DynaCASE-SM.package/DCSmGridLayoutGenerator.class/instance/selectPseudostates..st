as yet unclassified
selectPseudostates: statesCollection
	^ statesCollection select: [ :state | state isKindOf: DCSmPseudostate ]