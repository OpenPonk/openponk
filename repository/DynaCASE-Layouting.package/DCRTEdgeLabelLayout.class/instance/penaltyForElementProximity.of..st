as yet unclassified
penaltyForElementProximity: aPosition of: anEdge
	| closestDistance |
	closestDistance := (elements
		collect: [ :each | aPosition bounds nearestDistanceTo: each encompassingRectangle ]) min.
	^ 11 - closestDistance max: 0