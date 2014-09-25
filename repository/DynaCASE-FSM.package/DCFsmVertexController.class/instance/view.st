accessing
view
	^ view
		ifNil: [ 
			view := viewBlock value.
			view @ RTDraggable.
			view ]