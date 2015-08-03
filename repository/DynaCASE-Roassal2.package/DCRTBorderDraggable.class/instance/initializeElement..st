hooks
initializeElement: element
	self assert: [ background isNotNil ] description: 'BorderDraggable requires background element to operate.'.

	super initializeElement: element