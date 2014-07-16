testing
includesPoint: aPoint
	"Implementation is taken over from EllipseMorph>>containsPoint:"

	| invertedPoint radius other delta xOverY |
	invertedPoint := matrix inverseTransform: aPoint.
	(rectangle containsPoint: invertedPoint)
		ifFalse: [ ^ false ].	"quick elimination"
	radius := rectangle height asFloat / 2.
	other := rectangle width asFloat / 2.
	delta := invertedPoint - rectangle topLeft - (other @ radius).
	xOverY := rectangle width asFloat / rectangle height asFloat.
	^ (delta x asFloat / xOverY) squared + delta y squared <= radius squared