hooks
transformDistance: distanceAsPoint forElement: anElement
	| targetPosition |
	targetPosition := anElement position + distanceAsPoint.
	^ (background encompassingRectangle pointNearestTo: targetPosition) - anElement position