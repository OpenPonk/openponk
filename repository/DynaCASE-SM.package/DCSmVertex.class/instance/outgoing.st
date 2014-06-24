accessing
outgoing
	^ DCSmTransition allInstances select: [ :aTransition | aTransition source = self ]