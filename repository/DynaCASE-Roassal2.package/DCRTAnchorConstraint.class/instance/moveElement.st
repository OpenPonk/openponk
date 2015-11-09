as yet unclassified
moveElement
	| segment |
	segment := self anchorSegment first.
	element
		translateTo: anchorElement position + (segment vector normal * minDistance negated).
	(segment intersectRectangle: element encompassingRectangle)
		ifNotEmpty:
			[ :crossings | 
			element
				translateBy: segment vector normal * (minDistance + self computeExtraDistance) negated ].
	(element encompassingRectangle intersects: edge from encompassingRectangle)
		ifTrue: [ self moveAwayFromStart ].
	(element encompassingRectangle intersects: edge to encompassingRectangle)
		ifTrue: [ self moveAwayFromEnd ]