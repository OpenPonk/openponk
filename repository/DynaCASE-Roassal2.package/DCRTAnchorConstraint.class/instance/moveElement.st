as yet unclassified
moveElement
	| segment |
	segment := self anchorSegment first.
	element translateTo: anchorElement position + (segment vector normal * minDistance negated).
	(segment intersectRectangle: element encompassingRectangle)
		ifNotEmpty:
			[ :crossings | 
			element
				translateBy: segment vector normal * (minDistance + self computeExtraDistance) negated ]