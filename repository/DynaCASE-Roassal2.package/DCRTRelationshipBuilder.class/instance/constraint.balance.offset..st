public
constraint: aLabel balance: aFloat offset: aNumber
	DCRTConstraint
		stick: aLabel
			alongEdge: aLabel model
			balance: aFloat
			offset: aNumber;
		whenDragging: aLabel
			drawLineToPoint: [ 
					aLabel position
						nearestPointOnLineFrom: (aLabel model shape startingPointOf: aLabel model)
						to: (aLabel model shape endingPointOf: aLabel model) ]