event handling
mouseUp: anEvent
	draggedNode
		ifNotNil: [ 
			draggedNode := nil.
			self changed ]