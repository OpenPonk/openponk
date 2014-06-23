accessing
container
	^ container ifNil: [ container := DCVisualNullContainer new ]