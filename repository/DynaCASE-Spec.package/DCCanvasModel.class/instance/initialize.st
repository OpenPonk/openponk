initialize
initialize
	super initialize.
	self
		script: [ :view :canvas | 
			roassalView := view.
			view when: TRMouseLeftClick do: [ :event | self viewClicked: event ].
			view when: TRMouseRightClick do: [ :event | self cancelSelection ].
			view @ RTDraggableView.
			view @ RTZoomableView ]