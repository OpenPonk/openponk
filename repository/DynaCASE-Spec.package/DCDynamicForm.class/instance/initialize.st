initialization
initialize
	self reset.
	super initialize.
	heights := self defaultHeights.
	whenAccepted := [  ]