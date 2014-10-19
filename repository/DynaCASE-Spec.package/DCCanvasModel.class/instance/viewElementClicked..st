as yet unclassified
viewElementClicked: anElement
	selectedItemType
		ifNil: [ 
			| controller |
			controller := diagramController findControllerByView: anElement.
			self cancelSelection.
			self selectElement: anElement.
			self owner formModel editController: controller.
			self signalUpdate ].
	selectedItemType = #edge
		ifTrue: [ 
			selectedElement
				ifNil: [ 
					selectedElement := selectedItem value
						from: anElement;
						renderIn: roassalView;
						yourself ]
				ifNotNil: [ 
					| controller view |
					selectedElement to: anElement.
					controller := selectedElement complete.
					view := controller view.
					view when: TRMouseLeftClick do: [ :event | self viewEdgeClicked: event element ].
					self addMenuFor: view.
					self cancelSelection.
					self owner formModel editController: controller.
					self signalUpdate ] ]