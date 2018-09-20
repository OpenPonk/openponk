opening
updateViews
	| focusedController |
	focusedController := workbench focusedEditor
		ifNotNil: [ :editor | editor diagramController ].
	self project views
		do: [ :view | 
			view modelName: view model name.
			controllers
				detect: [ :ctrl | ctrl diagramView = view ]
				ifFound: [ :ctrl | 
					view isOpen: true.
					view layout: ctrl layout.
					view visibleElements: ctrl visibleElements.
					view updateFromRoassalView: ctrl view.
					view order: (controllers indexOf: ctrl).
					view isSelected: ctrl = focusedController ]
				ifNone: [ view
						isOpen: false;
						order: -1;
						isSelected: false ] ]