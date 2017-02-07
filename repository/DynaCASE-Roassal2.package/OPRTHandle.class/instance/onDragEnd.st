as yet unclassified
onDragEnd
	| previous next current |
	"remove the point if the angle between the two adjacent lines is near Pi"
	current := pointLink value.
	previous := pointLink hasPredecessor
		ifTrue: [ pointLink previousLink value ]
		ifFalse: [ edge from position ].
	next := pointLink hasSuccessor
		ifTrue: [ pointLink nextLink value ]
		ifFalse: [ edge to position ].
	(current onLineFrom: previous to: next within: 10)
		ifTrue: [ self removePoint ]