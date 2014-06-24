accessing
connectionPoint
	^ DCSmPseudostate allInstances select: [ :aPseudoState | aPseudoState state = self ]