accessing
strokeWidth
	^ strokeWidth ifNil: [ self defaultStrokeWidth ]