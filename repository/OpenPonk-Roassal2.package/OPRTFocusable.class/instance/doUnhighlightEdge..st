actions
doUnhighlightEdge: anEdge
	(anEdge attributes includesKey: #focusOriginalColor)
		ifFalse: [ ^ self ].
	anEdge shape color: (anEdge attributes at: #focusOriginalColor).
	anEdge update.
	anEdge attributes removeKey: #focusOriginalColor