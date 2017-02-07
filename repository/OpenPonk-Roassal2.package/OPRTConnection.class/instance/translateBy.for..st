updating
translateBy: aPoint for: anEdge
	router translateAllBy: aPoint.
	anEdge update.
	anEdge signalUpdate