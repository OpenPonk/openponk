api - unhighlight
unhighlight: aShapedObject
	(aShapedObject isKindOf: RTElement)
		ifTrue: [ self unhighlightElement: aShapedObject ].

	(aShapedObject isKindOf: RTEdge)
		ifTrue: [ self unhighlightEdge: aShapedObject ]