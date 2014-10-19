as yet unclassified
viewEdgeClicked: anElement
	selectedItemType
		ifNil: [ 
			| controller |
			controller := diagramController findControllerByView: anElement.
			self selectElement: anElement.
			self owner formModel editController: controller.
			self signalUpdate ]