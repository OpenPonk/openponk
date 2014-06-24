adding
add: anElement to: aPoint
	anElement position: 0@0.
	anElement moveBy: aPoint.
	content addFirst: anElement.
	anElement attached.
	self changed