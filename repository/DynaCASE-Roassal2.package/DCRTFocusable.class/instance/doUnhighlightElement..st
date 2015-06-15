actions
doUnhighlightElement: anElement
	(anElement isKindOf: RTEdge)
		ifTrue: [ ^ self doUnhighlightEdge: anElement ].
	(anElement hasAttribute: #focusOriginalColor)
		ifFalse: [ ^ self ].
	anElement shape borderColor: (anElement attributeAt: #focusOriginalColor).
	anElement removeAttributeAt: #focusOriginalColor.
	anElement update

	"
	(anElement attributes includesKey: #focusBoundingBox)
		ifFalse: [ ^ self ].
	(anElement attributes at: #focusBoundingBox) remove.
	anElement attributes removeKey: #focusBoundingBox"