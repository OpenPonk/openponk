selection handling
viewElementClicked: anElement
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
			self cancelSelection ].
	selectedItemType = #edge
		ifTrue: [ 
			selectedItem
				ifNotNil: [ 
					selectedElement
						ifNil: [ 
							selectedElement := selectedItem value
								from: anElement;
								renderIn: roassalView;
								yourself.
							self statusModel text: 'Click on the second of two elements to connect them.' ]
						ifNotNil: [ 
							| controller |
							selectedElement to: anElement.
							controller := selectedElement complete.
							controller view when: TRMouseLeftClick do: [ :event | self viewEdgeClicked: event element ].
							self cancelSelection ] ] ]