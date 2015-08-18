accessing
anchoredElement
	^ self hasPredecessor
		ifTrue: [ edge to ]
		ifFalse: [ edge from ]