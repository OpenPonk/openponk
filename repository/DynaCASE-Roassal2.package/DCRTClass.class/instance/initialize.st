initialization
initialize
	name := NewValueHolder value: ''.
	stereotype := NewValueHolder value: ''.
	attributes := OrderedCollection new asValueHolder.
	background := (RTBox new
		color: Color white;
		borderColor: Color black) element