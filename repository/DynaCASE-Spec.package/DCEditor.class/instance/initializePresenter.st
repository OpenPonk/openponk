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
			view @ RTZoomableView ].
	treeModel roots: #(#a #b #c #d).
	treeModel
		childrenBlock: [ :root | 
			root = #c
				ifTrue: [ #(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23) ]
				ifFalse: [ #(1 2 3 4 5 6 7) ] ]