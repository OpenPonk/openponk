adding
translateBy: aPoint for: anEdge
	points linksDo: [ :each | each value: each value + aPoint ].
	handlesActive
		ifTrue: [ 
			self removeHandlesFor: anEdge.
			self showHandlesFor: anEdge ].
	anEdge update.
	anEdge signalUpdate.