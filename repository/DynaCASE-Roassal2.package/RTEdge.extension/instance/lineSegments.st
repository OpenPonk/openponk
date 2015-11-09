*DynaCASE-Roassal2
lineSegments
	^ {(RTLineSegment
		from: (self shape startingPointOf: self)
		to: (self shape endingPointOf: self))}