geometry
center: aPoint
	| adjustedPoint |
	adjustedPoint := aPoint.
	radius ifNotNil: [ adjustedPoint := adjustedPoint - (radius / 2) ].
	super center: adjustedPoint