specs
defaultSpec
	^ SpecLayout composed
		newColumn: [ :c | 
					c
						newRow: #curveGroup;
						newRow: #shapeGroup;
						newRow: #nodeGroup ];
		yourself