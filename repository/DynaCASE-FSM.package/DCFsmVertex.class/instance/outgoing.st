as yet unclassified
outgoing
	^ DCFsmTransition allInstances select: [ :each | each source = self ]