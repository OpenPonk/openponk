hooks
view
	^ view ifNil: [ view := viewBlock value ]