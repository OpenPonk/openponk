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
			view @ RTZoomableView.
			view
				when: TRKeyDown
				do: [ :evt | 
					evt keyCombination = $+ shift
						ifTrue: [ RTZoomInMove on: view ].
					evt keyCombination = $- shift
						ifTrue: [ RTZoomOutMove on: view ].
					evt keyCombination = $+ control
						ifTrue: [ RTZoomInMove on: view ].
					evt keyCombination = $- control
						ifTrue: [ RTZoomOutMove on: view ].
					evt keyCombination = $+ command
						ifTrue: [ RTZoomInMove on: view ].
					evt keyCombination = $- command
						ifTrue: [ RTZoomOutMove on: view ] ] ]