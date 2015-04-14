rendering
addOrRemoveLinesFor: anEdge trachelShape: trachelShape
	| segmentsCount pointsCount shape col |
	col := self colorFor: anEdge.
	segmentsCount := trachelShape shapes size - 1.
	pointsCount := self points size.
	pointsCount - segmentsCount
		timesRepeat: [ 
			"add segments"
			shape := TRLineShape new.
			shape width: width.
			shape from: 0 @ 0 to: 0 @ 0.
			shape color: col.

			trachelShape addShape: shape.
			shape element: trachelShape element.
			shape announcer: trachelShape element announcer.
			shape addedIn: trachelShape canvas ].

	segmentsCount - pointsCount
		timesRepeat: [ 
			"remove segments"
			trachelShape removeLast remove ]