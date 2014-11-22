hooks
updateFor: edge trachelShape: trachelShape
	| fromPoint |
	fromPoint := attachPoint endingPointOf: edge.
	line
		ifNotNil: [ 
			| lineShape |
			lineShape := edge trachelShape shape1.
			lineShape class = TRBezierShape
				ifTrue: [ fromPoint := lineShape points second ] ].
	self updateFor: edge trachelShape: trachelShape from: fromPoint