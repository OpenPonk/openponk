accessing
initialize
	super initialize.
	multiplicity := (DCUmlMultiplicity new) min: '1'; max: '1'.