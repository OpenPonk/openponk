initialization
initializePresenter
	textEditorModel doItReceiver: (DCTextBindings new).
	roassalModel
		script: [ :view :canvas | 
			roassalView := view.
			textEditorModel doItReceiver view: view.
			view
				on: TRMouseLeftClick
				do: [ :event | self viewClicked: event ].
			view
				on: TRMouseRightClick
				do: [ :event | self cancelSelection ].
			view @ RTDraggableView.
			view @ RTZoomableView.
	view on: TRKeyDown do: [ :evt | 
	evt keyCombination = $+ shift ifTrue: [ RTZoomInMove on: view ].
	evt keyCombination = $- shift ifTrue: [ RTZoomOutMove on: view ].
	evt keyCombination = $+ control ifTrue: [ RTZoomInMove on: view ].
	evt keyCombination = $- control ifTrue: [ RTZoomOutMove on: view ].
	evt keyCombination = $+ command ifTrue: [ RTZoomInMove on: view ].
	evt keyCombination = $- command ifTrue: [ RTZoomOutMove on: view ].
 ].
]