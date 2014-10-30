initialization
initialize
	nameHolder := NewValueHolder value: ''.
	nameHolder whenChangedDo: [ self changed ]