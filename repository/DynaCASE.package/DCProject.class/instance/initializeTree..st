tree
initializeTree: aTree
	aTree roots: self diagrams.
	aTree
		menu: [ :menu | 
			| el menuBuilder |
			menuBuilder := DCMenuBuilder new menu: menu.
			aTree hasSelectedItem
				ifFalse: [ menuBuilder addItem: 'test' action: [  ] ].
			aTree hasSelectedItem
				ifTrue: [ 
					el := aTree selectedItem content.
					(el isKindOf: DCModelObject)
						ifTrue: [ 
							(el isKindOf: DCDiagram)
								ifTrue: [ menuBuilder addItem: 'Open' action: [ self openDiagramCommand: el ] ].
							menuBuilder addItem: 'Rename' action: [ self renameCommand: el ].
							menuBuilder addItem: 'Inspect' action: [ self inspectCommand: el ].
							(el isKindOf: DCDiagram)
								ifTrue: [ menuBuilder addItem: 'Edit' action: [ self editDiagramCommand: el ] ].
							(el isKindOf: DCNamedElement)
								ifTrue: [ 
									menuBuilder addItem: 'Edit' action: [ self editElementCommand: el ].
									menuBuilder addItem: 'Delete' action: [ self deleteElementCommand: el ] ] ] ] ].
	aTree
		displayBlock: [ :item | 
			| res |
			res := item.
			(item isKindOf: DCNamedElement)
				ifTrue: [ res := item name , ' (' , item class name , ')' ].
			(item isKindOf: DCDiagram)
				ifTrue: [ res := item name , ' (' , item class name , ')' ].
			res ].
	aTree
		childrenBlock: [ :it | 
			| col |
			col := OrderedCollection new.
			(it isKindOf: DCDiagram)
				ifTrue: [ col addAll: it elements ].
			(it isKindOf: DCNamedElement)
				ifTrue: [ 
					"responsibility of subclasses"
					 ].
			col ].
	aTree expandRoots.
	dirty whenChangedDo: [ aTree updateTree ]