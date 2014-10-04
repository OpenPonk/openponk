as yet unclassified
viewClicked: anEvent
	selectedItemType = #element
		ifTrue: [ 
			selectedItem
				ifNotNil: [ 
					| element controller |
					element := selectedItem new.
					diagram add: element.
					controller := diagramController findControllerByModel: element.
					controller view translateTo: anEvent position.
					controller view
						on: TRMouseLeftClick
						do: [ :event | self viewElementClicked: event element ].
					self cancelSelection.
					self statusModel text: '' ] ]