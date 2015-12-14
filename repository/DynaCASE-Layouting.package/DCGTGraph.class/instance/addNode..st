adding/removing
addNode: aDCGTNode
	(nodes includes: aDCGTNode) ifTrue: [ ^ self ].
	nodes add: aDCGTNode