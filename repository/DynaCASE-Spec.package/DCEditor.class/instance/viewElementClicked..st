as yet unclassified
viewElementClicked: anEvent
	selectedItemType = #transition
		ifTrue: [ 
			selectedItem
				ifNotNil: [ 
					selectedElement
						ifNil: [ selectedElement := anEvent element ]
						ifNotNil: [ 
							| element fromElement toElement |
							fromElement := (diagramController findControllerByView: selectedElement) model.
							toElement := (diagramController findControllerByView: anEvent element) model.
							element := selectedItem from: fromElement to: toElement.
							diagram add: element.
							selectedElement := nil.
							selectedItem := nil.
							self statusModel text: '' ] ] ]