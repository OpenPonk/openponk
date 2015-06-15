rendering
updateArcFor: anEdge trachelShape: trachelShape
	trachelShape from: (attachPoint startingPointOf: anEdge) to: (attachPoint endingPointOf: anEdge).
	trachelShape width: width.
	trachelShape radius: radius.
	trachelShape color: (self colorFor: anEdge).
	trachelShape resetPath