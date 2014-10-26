as yet unclassified
viewClicked: anEvent
	selectedItemType = #element
		ifTrue: [ 
			| controller view |
			controller := selectedItem value.
			view := controller view.
			view translateTo: anEvent position.
			view when: TRMouseLeftClick do: [ :event | self viewElementClicked: event element ].
			self addMenuFor: view.
			self cancelSelection.
			self focusOnController: controller.
			self signalUpdate ]