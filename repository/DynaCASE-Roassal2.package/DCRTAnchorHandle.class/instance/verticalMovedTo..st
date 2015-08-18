positioning
verticalMovedTo: aPoint
	| truncated top bottom |
	truncated := aPoint y.
	top := self anchoredElement encompassingRectangle top.
	bottom := self anchoredElement encompassingRectangle bottom.
	truncated < top
		ifTrue: [ truncated := top ].
	truncated > bottom
		ifTrue: [ truncated := bottom ].
	truncated = aPoint y
		ifFalse: [ self addSegmentTo: aPoint ].

	self basicMoveTo: self position x @ truncated