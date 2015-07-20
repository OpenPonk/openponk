rendering
arcShapeFor: anEdge
	| shape |
	shape := DCTRArcShape new.
	shape width: width.
	shape radius: radius.
	shape from: (attachPoint startingPointOf: anEdge) to: (attachPoint endingPointOf: anEdge).
	shape color: (self colorFor: anEdge).
	^ shape