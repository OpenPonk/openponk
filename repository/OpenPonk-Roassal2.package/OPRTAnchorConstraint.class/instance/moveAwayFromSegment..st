as yet unclassified
moveAwayFromSegment: aSegment
	(aSegment intersectRectangle: element encompassingRectangle)
		ifNotEmpty:
			[ :crossings | 
			element
				translateBy:
					aSegment vector normal
						* (minDistance + self computeExtraDistance) negated ]