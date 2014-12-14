private
rightClickMenu: menu
	| el menuBuilder |
	tree hasSelectedItem
		ifFalse: [ ^ self ].
	menuBuilder := DCMenuBuilder new menu: menu.
	el := tree selectedItem content.
	(el isKindOf: DCModelObject)
		ifTrue: [ 
			menuBuilder addItem: 'Rename' action: [ self renameCommand: el ].
			menuBuilder addItem: 'Inspect' action: [ self inspectCommand: el ].
			(el isKindOf: DCDiagram)
				ifTrue: [ 
					menuBuilder addItem: 'Delete' action: [ self deleteDiagramCommand: el ]
					"menuBuilder addItem: 'Edit' action: [ self editDiagramCommand: el ]" ].
			(el isKindOf: DCNamedElement)
				ifTrue: [ 
					"menuBuilder addItem: 'Edit' action: [ self editElementCommand: el ]."
					menuBuilder addItem: 'Delete' action: [ self deleteElementCommand: el ] ] ]