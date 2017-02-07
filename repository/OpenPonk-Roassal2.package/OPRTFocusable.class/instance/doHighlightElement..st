actions
doHighlightElement: anElement
	(anElement isKindOf: RTEdge)
		ifTrue: [ ^ self doHighlightEdge: anElement ].

	anElement attributeAt: #focusOriginalColor put: (anElement shape borderColorFor: anElement).
	anElement shape borderColor: Color blue.
	anElement update