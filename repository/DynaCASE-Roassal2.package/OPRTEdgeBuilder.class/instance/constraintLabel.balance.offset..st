labels
constraintLabel: labelName balance: aFloat offset: aNumber
	| label |
	label := self labelNamed: labelName.
	constraints
		add: [ :edge | 
			OPRTEdgeAlongConstraint
				stick: label
				alongEdge: edge
				balance: aFloat
				offset: aNumber.
			OPRTElementsConstraint
				whenDragging: label
				drawLineToPoint: [ ((edge shape startingPointOf: edge) + (edge shape endingPointOf: edge)) / 2 ] ]