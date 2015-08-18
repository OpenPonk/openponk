accessing
position
	^ element ifNil: [ initialPosition ] ifNotNil: [ element position ]