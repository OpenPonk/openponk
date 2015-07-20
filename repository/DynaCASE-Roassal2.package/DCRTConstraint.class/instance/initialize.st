initialization
initialize
	super initialize.
	self default.
	childX := [ :shape | shape width / 2 ].
	childY := [ :shape | shape height / 2 ]