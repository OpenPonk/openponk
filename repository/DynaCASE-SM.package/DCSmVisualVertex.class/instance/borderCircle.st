accessing
borderCircle
	borderCircle ifNil: [ borderCircle := DCVisualCircle new radius: self defaultBorderRadius ].
	self width: borderCircle width.
	self height: borderCircle height.
	^ borderCircle