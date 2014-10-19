as yet unclassified
doUnhighlightElement: anElement
	(anElement isKindOf: RTEdge)
		ifTrue: [ ^ self doUnhighlightEdge: anElement ].
	(anElement attributes includesKey: #focusBoundingBox)
		ifFalse: [ ^ self ].
	(anElement attributes at: #focusBoundingBox) remove.
	anElement attributes removeKey: #focusBoundingBox