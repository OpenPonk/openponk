as yet unclassified
applyRoute: aPath to: anEdge
	anEdge shape router points: aPath.
	anEdge update.
	anEdge signalUpdate.
	anEdge view signalUpdate