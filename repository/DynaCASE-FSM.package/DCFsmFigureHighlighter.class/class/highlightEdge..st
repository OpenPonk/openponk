api
highlightEdge: anEdge
	anEdge attributeAt: self name put: anEdge shape color.
	anEdge shape color: Color red.
	anEdge update.
	anEdge signalUpdate