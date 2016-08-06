initialization
initialize
	super initialize.
	self
		script: [ :view :canvas | 
			roassalView := view.
			view when: TRMouseLeftClick do: [ :event | self viewClicked: event ].
			view @ RTDraggableView.
			view @ (RTZoomableView new min: 0.25 max: 4).
			view @ (RTGridView new gridSize: 20).
			view canvas camera
				addCallback:
					(TRCameraScaleCallback
						block: [ :newScale | 
							self editor zoomLabel
								label:
									(newScale < 1
										ifTrue: [ '   ' ]
										ifFalse: [ '' ]) , (newScale * 100) rounded asString , '%' ]) ]