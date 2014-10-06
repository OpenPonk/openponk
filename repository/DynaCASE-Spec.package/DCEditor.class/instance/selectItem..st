selection handling
selectItem: aBlock
	selectedItem
		ifNil: [ selectedItem := aBlock ]
		ifNotNil: [ 
			selectedItem = aBlock
				ifTrue: [ selectedItem := nil ]
				ifFalse: [ selectedItem := aBlock ] ]