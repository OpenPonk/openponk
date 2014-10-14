interaction
initialize
	super initialize.
	activations := Dictionary new.
	activations add: (Association key: 0 value: Color transparent)