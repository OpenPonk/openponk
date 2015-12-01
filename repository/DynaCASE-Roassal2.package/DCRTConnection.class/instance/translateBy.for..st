adding
translateBy: aPoint for: anEdge
	router translateAllBy: aPoint.
	handlesActive
		ifTrue: [ self removeHandlesFor: anEdge.
			self showHandlesFor: anEdge ].
	anEdge update.
	anEdge signalUpdate