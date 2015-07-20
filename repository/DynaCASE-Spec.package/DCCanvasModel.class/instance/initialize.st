initialization
initialize
	super initialize.
	self
		script: [ :view :canvas | 
			roassalView := view.
			view when: TRMouseLeftClick do: [ :event | self viewClicked: event ].
			view @ RTDraggableView.
			view @ RTZoomableView ]