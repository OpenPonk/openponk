actions
doUnhighlightClass: anElement
	(anElement attributes includesKey: #focusBoundingBox)
		ifFalse: [ ^ self ].
	(anElement attributes at: #focusBoundingBox) remove.
	anElement attributes removeKey: #focusBoundingBox