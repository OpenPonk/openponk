initialization
initialize
	super initialize.
	matchBlock := [ :aValue | self name = aValue asString ]