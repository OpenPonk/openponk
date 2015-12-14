accessing
from: aDCGTNode
	|oldRef|
	from = aDCGTNode ifTrue: [ ^ self ].
	oldRef := from.
	from := aDCGTNode.
	oldRef ifNotNil: [ oldRef removeEdge: self ].
	from ifNotNil: [ from addEdge: self ]