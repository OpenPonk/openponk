actions
doHighlightElement: anElement
	(anElement isKindOf: RTEdge)
		ifTrue: [ ^ self doHighlightEdge: anElement ].

	"BC compat"
	(anElement model isMemberOf: DCRTClass)
		ifTrue: [ ^ self doHighlightClass: anElement ].

	anElement attributeAt: #focusOriginalColor put: anElement shape borderColor.
	anElement shape borderColor: Color blue.
	anElement update