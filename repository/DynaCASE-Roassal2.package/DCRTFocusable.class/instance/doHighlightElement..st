actions
doHighlightElement: anElement
	| boundingBox |
	(anElement isKindOf: RTEdge)
		ifTrue: [ ^ self doHighlightEdge: anElement ].
	anElement attributeAt: #focusOriginalColor put: anElement shape borderColor.
	anElement shape borderColor: Color blue.
	anElement update.
		
	"boundingBox := self newBoundingBoxFor: anElement.
	anElement attributes at: #focusBoundingBox put: boundingBox.
	anElement view add: boundingBox"