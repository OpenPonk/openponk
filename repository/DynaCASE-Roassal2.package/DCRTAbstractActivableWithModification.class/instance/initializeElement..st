hooks
initializeElement: element
	activations at: 0 put: element shape color deepCopy.
	super initializeElement: element