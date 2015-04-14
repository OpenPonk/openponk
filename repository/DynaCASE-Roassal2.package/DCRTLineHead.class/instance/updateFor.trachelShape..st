hooks
updateFor: edge trachelShape: trachelShape
	| fromPoint |
	fromPoint := attachPoint startingPointOf: edge.
	line
		ifNotNil: [ 
			| lineShape |
			lineShape := edge trachelShape shape1.
			lineShape class = TRBezierShape
				ifTrue: [ fromPoint := lineShape points allButLast last ] ].
	self updateFor: edge trachelShape: trachelShape from: fromPoint