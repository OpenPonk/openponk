adding/removing
removeEdge: aDCGTEdge
	(edges includes: aDCGTEdge)
		ifFalse: [ ^ self ].
	edges remove: aDCGTEdge