selection handling
viewEdgeClicked: anElement
	selectedItemType = #form
		ifTrue: [ 
			| controller |
			controller := diagramController findControllerByView: anElement.
			self formModel editController: controller.
			diagramController
				deactivateAllElements;
				activateElement: anElement ].
	selectedItemType = #delete
		ifTrue: [ 
			| controller |
			controller := diagramController findControllerByView: anElement.
			diagram remove: controller model.
			self cancelSelection ]