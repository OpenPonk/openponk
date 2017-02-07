actions
doHighlightEdge: anEdge
	anEdge attributes at: #focusOriginalColor put: anEdge shape color.
	anEdge shape color: Color blue.
	anEdge update