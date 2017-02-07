actions
doHighlightClass: anElement
	| boundingBox |
	boundingBox := self newBoundingBoxFor: anElement.
	anElement attributes at: #focusBoundingBox put: boundingBox.
	anElement view add: boundingBox