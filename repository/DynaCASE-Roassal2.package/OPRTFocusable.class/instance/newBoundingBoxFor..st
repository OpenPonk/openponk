instance creation
newBoundingBoxFor: anElement
	| boundingBox |
	boundingBox := RTBox new
		color: Color transparent;
		borderColor: Color blue;
		element.
	OPRTElementsConstraint keepExtentOf: boundingBox like: anElement plus: 3 @ 3.
	TRConstraint stick: boundingBox onTheCenterOf: anElement.
	^ boundingBox