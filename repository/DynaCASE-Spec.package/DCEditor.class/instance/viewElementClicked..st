as yet unclassified
viewElementClicked: anElement
	selectedItemType = #form
		ifTrue: [ 
			| controller |
			controller := diagramController findControllerByView: anElement.
			self formModel controller: controller ].
	selectedItemType = #delete
		ifTrue: [ 
			| controller |
			controller := diagramController findControllerByView: anElement.
			diagram remove: controller model.
			self cancelSelection ].
	selectedItemType = #transition
		ifTrue: [ 
			selectedItem
				ifNotNil: [ 
					selectedElement
						ifNil: [ 
							selectedElement := anElement.
							interactiveLine := (DCInteractiveLine lineType: selectedItem lineType from: selectedElement on: diagramController)
								attachToMouse: anElement position ]
						ifNotNil: [ 
							| element fromElement toElement controller |
							fromElement := (diagramController findControllerByView: selectedElement) model.
							toElement := (diagramController findControllerByView: anElement) model.
							element := selectedItem from: fromElement to: toElement.
							diagram add: element.
							diagramController updateView.
							controller := diagramController findControllerByModel: element.
							controller view
								on: TRMouseLeftClick
								do: [ :event | self viewEdgeClicked: controller view	"event element" ].
							self cancelSelection.
							self statusModel text: ''.
							interactiveLine cancel ] ] ]