adding/removing
addEdge: aDCGTEdge
	(edges includes: aDCGTEdge)
		ifTrue: [ ^ self ].
	edges add: aDCGTEdge