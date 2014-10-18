initialization
initializePresenter
	textEditorModel doItReceiver: DCTextEditorBindings new.
	self initializeTopMenu.
	roassalModel
		script: [ :view :canvas | 
			roassalView := view.
			textEditorModel doItReceiver view: view.
			view when: TRMouseLeftClick do: [ :event | self viewClicked: event ].
			view when: TRMouseRightClick do: [ :event | self cancelSelection ].	"			view @ DCRTScrolledDraggableView."
			view @ RTDraggableView.
			view @ RTZoomableView ]