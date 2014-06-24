accessing
incoming
	^ DCSmTransition allInstances select: [ :aTransition | aTransition target = self ]