hooks
initialize
	super initialize.
	isActive := false.
	handleFactory := DCRTHandleFactory new.
	self resetHandles