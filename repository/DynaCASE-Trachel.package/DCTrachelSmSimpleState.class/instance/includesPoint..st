testing
includesPoint: aPoint
	| invertedPoint |
	invertedPoint := matrix inverseTransform: aPoint.
	^ rectangle containsPoint: invertedPoint