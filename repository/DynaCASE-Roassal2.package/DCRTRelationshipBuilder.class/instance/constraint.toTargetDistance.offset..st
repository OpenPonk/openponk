public
constraint: aLabel toTargetDistance: aNumber offset: anotherNumber
	DCRTConstraint
		stick: aLabel
			nearEndOfEdge: aLabel model
			distance: aNumber
			offset: anotherNumber;
		whenDragging: aLabel drawLineToPoint: [ aLabel model shape endingPointOf: aLabel model ]