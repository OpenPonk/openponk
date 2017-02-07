private
checkLineToSelfFor: anEdge
	anEdge from = anEdge to
		ifTrue: [ self createLineToSelf ]