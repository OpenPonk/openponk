public - hooks
startingPointOf: anEdge
	| points rect |
	points := anEdge shape points.
	rect := points
		ifEmpty: [ anEdge to encompassingRectangle ]
		ifNotEmpty: [ points first corner: points first ].
	^ self attachPointFor: anEdge from: anEdge from encompassingRectangle to: rect