as yet unclassified
moveElement
	| segment from to |
	segment := self anchorSegment first.
	element
		translateTo: anchorElement position + (segment vector normal * minDistance negated).
	self moveAwayFromSegment: segment.
	from := edge from encompassingRectangle expandBy: minDistance abs.
	to := edge to encompassingRectangle expandBy: minDistance abs.
	balance > 0 & (element encompassingRectangle intersects: from)
		ifTrue: [ self moveAwayFrom: from via: segment vector ].
	balance < 0 & (element encompassingRectangle intersects: to)
		ifTrue: [ self moveAwayFrom: to via: segment vector negated ]