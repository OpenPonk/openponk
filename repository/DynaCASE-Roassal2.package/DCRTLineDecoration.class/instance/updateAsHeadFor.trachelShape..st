private
updateAsHeadFor: edge trachelShape: trachelShape
	| f |
	f := attachPoint startingPointOf: edge.
	line
		ifNotNil: [ 
			| tShape |
			tShape := edge trachelShape shape1.
			tShape class = TRBezierShape
				ifTrue: [ f := tShape points allButLast last ] ].
	trachelShape
		from: f;
		to: (attachPoint endingPointOf: edge);
		color: (self colorFor: edge);
		width: (self widthFor: edge);
		resetPath