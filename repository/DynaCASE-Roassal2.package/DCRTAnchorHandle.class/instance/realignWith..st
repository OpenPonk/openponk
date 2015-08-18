positioning
realignWith: aLink
	aLink isVertical
		ifTrue: [ 
			| newY |
			newY := aLink y < self y
				ifTrue: [ #top ]
				ifFalse: [ #bottom ].
			element translateTo: self x @ (self anchoredElement encompassingRectangle perform: newY) ].
	aLink isHorizontal
		ifTrue: [ 
			| newX |
			newX := aLink x < self x
				ifTrue: [ #left ]
				ifFalse: [ #right ].
			element translateTo: (self anchoredElement encompassingRectangle perform: newX) @ self y ]