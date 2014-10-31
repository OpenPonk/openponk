public
constraint: aLabel toSourceDistance: aNumber offset: anotherNumber
	DCRTConstraint
		stick: aLabel
			nearStartOfEdge: aLabel model
			distance: aNumber
			offset: anotherNumber;
		whenDragging: aLabel drawLineToPoint: [ aLabel model shape startingPointOf: aLabel model ]