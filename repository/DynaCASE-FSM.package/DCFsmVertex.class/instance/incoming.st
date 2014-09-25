as yet unclassified
incoming
	^ DCFsmTransition allInstances select: [ :each | each target = self ]