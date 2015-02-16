running
move
	"moves shape according to edge positions and settings"

	| vector startPoint endPoint |
	startPoint := edge shape startingPointOf: edge.
	endPoint := edge shape endingPointOf: edge.
	vector := endPoint - startPoint.
	^ shape translateTo: startPoint + (vector * balance) + (vector normal * offset)