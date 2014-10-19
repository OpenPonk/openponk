actions
doHighlightElement: anElement
	| boundingBox |
	(anElement isKindOf: RTEdge)
		ifTrue: [ ^ self doHighlightEdge: anElement ].
	boundingBox := self newBoundingBoxFor: anElement.
	anElement attributes at: #focusBoundingBox put: boundingBox.
	anElement view add: boundingBox