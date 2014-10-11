initialization
initializePresenter
	textEditorModel doItReceiver: DCTextEditorBindings new.
	roassalModel
		script: [ :view :canvas | 
			roassalView := view.
			textEditorModel doItReceiver view: view.
			view when: TRMouseLeftClick do: [ :event | self viewClicked: event ].
			view when: TRMouseRightClick do: [ :event | self cancelSelection ].
			view @ RTDraggableView.
			view @ RTZoomableView ]