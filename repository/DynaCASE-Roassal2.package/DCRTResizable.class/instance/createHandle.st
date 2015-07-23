instance creation
createHandle
	| handle |
	handle := RTBox new
		size: 6;
		color: Color black;
		element.
	handle @ RTDraggable.
	^ handle