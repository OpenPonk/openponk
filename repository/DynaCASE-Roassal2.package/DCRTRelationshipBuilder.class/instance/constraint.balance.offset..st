public
constraint: aLabel balance: aFloat offset: aNumber
	DCRTEdgeAlongConstraint
		stick: aLabel
		alongEdge: aLabel model
		balance: aFloat
		offset: aNumber.
	DCRTElementsConstraint
		whenDragging: aLabel
		drawLineToPoint: [ ((aLabel model shape startingPointOf: aLabel model) + (aLabel model shape endingPointOf: aLabel model)) / 2 ]