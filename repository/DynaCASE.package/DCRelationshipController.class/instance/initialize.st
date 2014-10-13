interaction
initialize
	super initialize.
	activation := Dictionary new.
	activation add: (Association key: 0 value: self defaultColor)