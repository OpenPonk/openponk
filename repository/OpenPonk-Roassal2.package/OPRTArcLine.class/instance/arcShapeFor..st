rendering
arcShapeFor: anEdge
	| shape |
	shape := OPTRArcShape new.
	shape width: width.
	shape radius: radius.
	shape from: (attachPoint startingPointOf: anEdge) to: (attachPoint endingPointOf: anEdge).
	shape color: (self colorFor: anEdge).
	^ shape