public - moving
move: aShape nearStartOfEdge: anEdge distance: aNumber offset: anotherNumber
	| vector startPoint endPoint |
	startPoint := anEdge shape startingPointOf: anEdge.
	endPoint := anEdge shape endingPointOf: anEdge.
	vector := endPoint - startPoint.
	vector isZero
		ifTrue: [ aShape translateTo: startPoint ]
		ifFalse: [ aShape translateTo: startPoint + (vector normalized * aNumber) + (vector normal * anotherNumber) ].
	^ aShape