selection handling
viewElementClicked: anElement
	selectedItemType = #form
		ifTrue: [ 
			| controller |
			controller := diagramController findControllerByView: anElement.
			self cancelSelection.
			(activeElement := anElement) announce: DCTRSelectedEvent.
			self formModel editController: controller.
			roassalView signalUpdate ].
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
							| controller view |
							selectedElement to: anElement.
							controller := selectedElement complete.
							view := controller view.
							view when: TRMouseLeftClick do: [ :event | self viewEdgeClicked: event element ].
							self addMenuFor: view.
							self cancelSelection.
							(activeElement := view) announce: DCTRSelectedEvent.
							self formModel editController: controller.
							roassalView signalUpdate ] ] ]