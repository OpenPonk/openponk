as yet unclassified
viewElementClicked: anEvent
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
			self cancelSelection ].
	selectedItemType = #transition
		ifTrue: [ 
			selectedItem
				ifNotNil: [ 
					selectedElement
						ifNil: [ selectedElement := anEvent element ]
						ifNotNil: [ 
							| element fromElement toElement controller |
							fromElement := (diagramController findControllerByView: selectedElement) model.
							toElement := (diagramController findControllerByView: anEvent element) model.
							element := selectedItem from: fromElement to: toElement.
							diagram add: element.
							controller := diagramController findControllerByModel: element.
							controller view
								on: TRMouseLeftClick
								do: [ :event | self viewEdgeClicked: event ].
							self cancelSelection.
							self statusModel text: '' ] ] ]