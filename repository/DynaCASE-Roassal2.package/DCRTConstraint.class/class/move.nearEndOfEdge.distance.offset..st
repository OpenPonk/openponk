public - moving
move: aShape nearEndOfEdge: anEdge distance: aNumber offset: anotherNumber
	| vector startPoint endPoint |
	startPoint := anEdge shape startingPointOf: anEdge.
	endPoint := anEdge shape endingPointOf: anEdge.
	vector := endPoint - startPoint.
	vector isZero
		ifTrue: [ aShape translateTo: endPoint ]
		ifFalse: [ aShape translateTo: endPoint - (vector normalized * aNumber) + (vector normal * anotherNumber) ].
	^ aShape