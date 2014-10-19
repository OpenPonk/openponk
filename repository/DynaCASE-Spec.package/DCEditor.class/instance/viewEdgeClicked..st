selection handling
viewEdgeClicked: anElement
	selectedItemType = #form
		ifTrue: [ 
			| controller |
			controller := diagramController findControllerByView: anElement.
			self cancelSelection.
			(activeElement := anElement) announce: DCTRSelectedEvent.
			self formModel editController: controller.
			roassalView signalUpdate ]