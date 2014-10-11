initialization
initialize
	name := NewValueHolder value: ''.
	stereotype := NewValueHolder value: ''.
	attributes := OrderedCollection new asValueHolder.
	methods := OrderedCollection new asValueHolder.
	background := (RTBox new
		color: Color transparent;
		borderColor: Color black) element