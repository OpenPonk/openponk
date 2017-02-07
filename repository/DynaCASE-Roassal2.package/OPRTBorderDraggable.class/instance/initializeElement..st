hooks
initializeElement: anElement
	self
		assert: [ background isNotNil ]
		description: 'BorderDraggable requires background element to operate.'.
	super initializeElement: anElement.