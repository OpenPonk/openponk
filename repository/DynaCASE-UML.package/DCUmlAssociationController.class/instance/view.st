accessing
view
	^ view ifNil: [ view := self createView ]