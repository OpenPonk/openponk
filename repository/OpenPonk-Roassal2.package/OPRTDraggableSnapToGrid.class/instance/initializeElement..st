hooks
initializeElement: element
	super initializeElement: element.
	element when: TRMouseDragStart do: [ :event | totalDistance := 0 @ 0 ]