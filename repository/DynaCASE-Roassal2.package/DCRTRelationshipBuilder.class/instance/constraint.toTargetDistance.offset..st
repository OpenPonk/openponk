public
constraint: aLabel toTargetDistance: aNumber offset: anotherNumber
	DCRTEdgeEndConstraint
		stick: aLabel
		near: #end
		ofEdge: aLabel model
		distance: aNumber
		offset: anotherNumber.
	DCRTElementsConstraint
		whenDragging: aLabel
		drawLineToPoint: [ 0.9 * (aLabel model shape endingPointOf: aLabel model) + (0.1 * (aLabel model shape startingPointOf: aLabel model)) ]