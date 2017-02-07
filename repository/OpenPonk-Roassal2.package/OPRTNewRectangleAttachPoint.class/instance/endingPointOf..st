public - hooks
endingPointOf: anEdge
	| points rect |
	points := anEdge shape points.
	rect := points
		ifEmpty: [ anEdge from encompassingRectangle ]
		ifNotEmpty: [ points last corner: points last ].
	^ self attachPointFor: anEdge from: anEdge to encompassingRectangle to: rect