public
constraint: aLabel toSourceDistance: aNumber offset: anotherNumber
	DCRTEdgeEndConstraint
		stick: aLabel
		nearStartOfEdge: aLabel model
		distance: aNumber
		offset: anotherNumber.
	DCRTElementsConstraint
		whenDragging: aLabel
		drawLineToPoint: [ (aLabel model shape startingPointOf: aLabel model) * 0.9 + ((aLabel model shape endingPointOf: aLabel model) * 0.1) ]