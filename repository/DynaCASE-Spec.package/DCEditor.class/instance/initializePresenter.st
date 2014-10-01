initialization
initializePresenter
	roassalModel
		script: [ :view :canvas | 
			roassalView := view.
			view
				on: TRMouseLeftClick
				do: [ :event | self viewClicked: event ].
			view @ RTDraggableView.
			view @ RTZoomableView.
			view on: TRMouseLeftClick do: [ RTZoomInMove on: view ].	
			view on: TRMouseRightClick do: [ RTZoomOutMove on: view ].
			 ]