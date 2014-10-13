selection handling
viewClicked: anEvent
	selectedItemType = #element
		ifTrue: [ 
			selectedItem
				ifNotNil: [ 
					| controller |
					controller := selectedItem value.
					controller view translateTo: anEvent position.
					controller view when: TRMouseLeftClick do: [ :event | self viewElementClicked: event element ].
					self cancelSelection.
					(activeElementsController := controller) activateLevel: 20 color: Color blue.
					self formModel editController: controller.
					roassalView signalUpdate ] ]