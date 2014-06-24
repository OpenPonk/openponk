event handling
mouseMove: anEvent
	draggedNode
		ifNotNil: [ 
			draggedNode moveBy: anEvent endPoint - anEvent startPoint.
			self changed ]