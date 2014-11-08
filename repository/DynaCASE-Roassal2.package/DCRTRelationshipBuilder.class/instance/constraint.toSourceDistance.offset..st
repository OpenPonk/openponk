public
constraint: aLabel toSourceDistance: aNumber offset: anotherNumber
	DCRTConstraint
		stick: aLabel
			near: #start
			ofEdge: aLabel model
			distance: aNumber
			offset: anotherNumber;
		whenDragging: aLabel
			drawLineToPoint: [ (aLabel model shape startingPointOf: aLabel model) * 0.9 + ((aLabel model shape endingPointOf: aLabel model) * 0.1) ]