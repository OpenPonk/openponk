as yet unclassified
activateItem: anItem
	selectedItem
		ifNil: [ selectedItem := anItem ]
		ifNotNil: [ 
			selectedItem button state: false.
			selectedItem = anItem
				ifTrue: [ selectedItem := nil ]
				ifFalse: [ selectedItem := anItem ] ].
	selectedItem ifNotNil: [ selectedItem button state: true ]