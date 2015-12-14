accessing
to: aDCGTNode
	|oldRef|
	to = aDCGTNode ifTrue: [ ^ self ].
	oldRef := to.
	to := aDCGTNode.
	oldRef ifNotNil: [ oldRef removeEdge: self ].
	to ifNotNil: [ to addEdge: self ]