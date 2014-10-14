selection handling
viewClicked: anEvent
	selectedItemType = #element
		ifTrue: [ 
			selectedItem
				ifNotNil: [ 
					| controller view |
					controller := selectedItem value.
					view := controller view.
					view translateTo: anEvent position.
					view when: TRMouseLeftClick do: [ :event | self viewElementClicked: event element ].
					self cancelSelection.
					(activeElement := view) announce: DCTRSelectedEvent.
					self formModel editController: controller.
					roassalView signalUpdate ] ]