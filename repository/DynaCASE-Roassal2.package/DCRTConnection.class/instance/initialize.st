initialization
initialize
	super initialize.
	router := DCRTInteractiveRouter new.
	segments := OrderedCollection new.
	handles := OrderedCollection new.
	midpointHandles := OrderedCollection new.
	handlesActive := false