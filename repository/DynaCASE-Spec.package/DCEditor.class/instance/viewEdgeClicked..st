as yet unclassified
viewEdgeClicked: anEvent
	Transcript crShow: 'viewEdgeClicked'.
	selectedItemType = #form
		ifTrue: [ 
			| controller |
			controller := diagramController findControllerByView: anEvent element.
			self formModel controller: controller ].
	selectedItemType = #delete
		ifTrue: [ 
			| controller |
			controller := diagramController findControllerByView: anEvent element.
			diagram remove: controller model.
			self cancelSelection ]