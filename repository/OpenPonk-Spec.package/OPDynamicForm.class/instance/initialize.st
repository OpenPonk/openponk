initialization
initialize
	self reset.
	super initialize.
	heading := OPWidgetHeading forLabel: 'Properties'.
	heights := self defaultHeights.
	whenAccepted := [  ]