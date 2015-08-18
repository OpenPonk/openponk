positioning
horizontalMovedTo: aPoint
	| truncated left right |
	truncated := aPoint x.
	left := self anchoredElement encompassingRectangle left.
	right := self anchoredElement encompassingRectangle right.
	truncated < left
		ifTrue: [ truncated := left ].
	truncated > right
		ifTrue: [ truncated := right ].
	truncated = aPoint x
		ifFalse: [ self addSegmentTo: aPoint ].

	self basicMoveTo: truncated @ self position y