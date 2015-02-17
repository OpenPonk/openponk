attach point
withShorterDistanceWithOffsetAttachPoint
	| ap |
	ap := RTShorterDistanceWithOffsetAttachPoint new.
	self attachPoint: ap.
	^ ap