adding/removing
removeNode: aDCGTNode
	(nodes includes: aDCGTNode) ifFalse: [ ^ self ].
	nodes remove: aDCGTNode