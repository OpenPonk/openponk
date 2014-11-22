private
updateAsTailFor: edge trachelShape: trachelShape
	| f |
	f := attachPoint endingPointOf: edge.
	line
		ifNotNil: [ 
			| tShape |
			tShape := edge trachelShape shape1.
			tShape class = TRBezierShape
				ifTrue: [ f := tShape points second ] ].
	trachelShape
		from: f;
		to: (attachPoint startingPointOf: edge);
		color: (self colorFor: edge);
		width: (self widthFor: edge);
		resetPath