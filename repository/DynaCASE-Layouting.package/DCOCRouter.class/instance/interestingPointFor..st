as yet unclassified
interestingPointFor: anElement
	"Retrieve an interesting point for an element. This are corners of the element and some fixed number of connectors (for now centres)."

	| r |
	r := anElement encompassingRectangle expandBy: 10.
	^ (r corners , (self sideCentersFor: r)) asSet