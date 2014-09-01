as yet unclassified
viewEdgeClicked: anEvent
	selectedItemType = #form
		ifTrue: [ 
			| controller |
			controller := diagramController findControllerByView: anEvent element.
			self formModel controller: controller ]