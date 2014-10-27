as yet unclassified
viewElementClicked: anElement
	selectedItemType ifNil: [ self focusOnElement: anElement ].
	selectedItemType = #edge
		ifTrue: [ 
			selectedElement
				ifNil: [ 
					self
						selectElement:
							(selectedItem value
								from: anElement;
								renderIn: roassalView;
								yourself) ]
				ifNotNil: [ 
					| controller view |
					selectedElement to: anElement.
					controller := selectedElement complete.
					view := controller view.
					view when: TRMouseLeftClick do: [ :event | self viewEdgeClicked: event element ].
					self addMenuFor: view.
					self cancelSelection.
					self focusOnController: controller.
					self signalUpdate ] ]