hooks
view
	^ view ifNil: [ view := self createView ]