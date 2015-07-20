api - highlight
highlight: aShapedObject with: aColor
	(aShapedObject isKindOf: RTElement)
		ifTrue: [ self highlightElement: aShapedObject with: aColor ].

	(aShapedObject isKindOf: RTEdge)
		ifTrue: [ self highlightEdge: aShapedObject with: aColor ]