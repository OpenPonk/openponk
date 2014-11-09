public - moving
move: aShape alongEdge: anEdge balance: aFloat offset: aNumber
	| vector startPoint endPoint |
	startPoint := anEdge shape startingPointOf: anEdge.
	endPoint := anEdge shape endingPointOf: anEdge.
	vector := endPoint - startPoint.
	^ aShape translateTo: startPoint + (vector * aFloat) + (vector normal * aNumber)