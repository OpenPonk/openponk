selection handling
viewEdgeClicked: anElement
	selectedItemType = #form
		ifTrue: [ 
			| controller |
			controller := diagramController findControllerByView: anElement.
			self cancelSelection.
			(activeElementsController := controller) activateLevel: 20 color: Color blue.
			self formModel editController: controller.
			roassalView signalUpdate ].
	selectedItemType = #delete
		ifTrue: [ 
			| controller |
			controller := diagramController findControllerByView: anElement.
			diagram remove: controller model.
			self cancelSelection ]