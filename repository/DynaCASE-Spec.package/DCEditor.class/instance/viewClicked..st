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
					roassalView signalUpdate.
					self cancelSelection ] ]