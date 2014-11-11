running
move
	| vector startPoint endPoint |
	startPoint := edge shape startingPointOf: edge.
	endPoint := edge shape endingPointOf: edge.
	vector := endPoint - startPoint.
	^ shape translateTo: startPoint + (vector * balance) + (vector normal * offset)