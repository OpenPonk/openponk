hooks
updateFor: anEdge trachelShape: trachelShape
	| fromPoint |
	fromPoint := self sourcePointOf: anEdge.
	line
		ifNotNil: [ 
			| lineShape |
			lineShape := anEdge trachelShape shape1.
			lineShape class = TRBezierShape
				ifTrue: [ fromPoint := self sourcePointOfBezier: lineShape ] ].
	self updateFor: anEdge trachelShape: trachelShape from: fromPoint