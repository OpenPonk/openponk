as yet unclassified
rebuildFor: anEdge
	anEdge shape removeHandlesFor: anEdge.
	anEdge shape showHandlesFor: anEdge.
	anEdge update.
	anEdge signalUpdate