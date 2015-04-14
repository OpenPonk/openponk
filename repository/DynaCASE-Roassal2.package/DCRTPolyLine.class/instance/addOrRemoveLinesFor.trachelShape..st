rendering
addOrRemoveLinesFor: anEdge trachelShape: trachelShape
	| segmentsCount pointsCount shape canvas |
	canvas := trachelShape canvas.
	segmentsCount := (trachelShape shapes select: [ :each | each isKindOf: TRAbstractLineShape ]) size - 1.	"-1 base segment"
	pointsCount := self points size.
	pointsCount - segmentsCount
		timesRepeat: [ 
			"add segments"
			shape := self lineSegmentFor: anEdge from: 0 @ 0 to: 0 @ 0.

			trachelShape addShapeFirst: shape.
			shape element: trachelShape element.
			shape announcer: trachelShape element announcer.
			shape addedIn: canvas ].

	segmentsCount - pointsCount
		timesRepeat: [ 
			"remove segments"
			trachelShape removeFirst remove ]