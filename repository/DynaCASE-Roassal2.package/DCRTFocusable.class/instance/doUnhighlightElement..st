actions
doUnhighlightElement: anElement
	(anElement isKindOf: RTEdge)
		ifTrue: [ ^ self doUnhighlightEdge: anElement ].

	(anElement hasAttribute: #focusOriginalColor)
		ifFalse: [ ^ self ].

	anElement shape borderColor: (anElement attributeAt: #focusOriginalColor).
	anElement removeAttributeAt: #focusOriginalColor.
	anElement update