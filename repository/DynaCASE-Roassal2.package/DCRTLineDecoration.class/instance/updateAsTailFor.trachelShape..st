as yet unclassified
updateAsTailFor: edge trachelShape: trachelShape
	| t |
	t := attachPoint endingPointOf: edge.
	line ~= nil
		ifTrue: [ 
			| tShape |
			tShape := edge trachelShape shape1.
			tShape class = TRBezierShape
				ifTrue: [ t := tShape points second ] ].
	trachelShape
		from: (attachPoint startingPointOf: edge);
		to: t;
		color: (self colorFor: edge);
		width: (self widthFor: edge);
		resetPath