initialization
initializeTree: aTree
	aTree roots: (Array with: self model).
	aTree
		menu: [ :menu | 
			| el |
			aTree hasSelectedItem
				ifTrue: [ 
					el := aTree selectedItem content.
					(el isKindOf: DCModelObject)
						ifTrue: [ 
							menu
								addGroup: [ :group | 
									group
										addItem: [ :item | 
											item
												name: 'Inspect';
												action: [ el inspect ] ].
									(el isKindOf: DCNamedElement)
										ifTrue: [ 
											group
												addItem: [ :item | 
													item
														name: 'Delete';
														action: [ self model remove: el ] ] ] ] ] ] ].
	aTree
		displayBlock: [ :item | 
			| res |
			res := item.
			(item isKindOf: DCNamedElement)
				ifTrue: [ res := item name , ' (' , item class name , ')' ].
			(item isKindOf: DCDiagram)
				ifTrue: [ res := item class name ].
			res ].
	aTree
		childrenBlock: [ :it | 
			| col |
			col := OrderedCollection new.
			(it isKindOf: DCDiagram)
				ifTrue: [ col addAll: it elements ].
			(it isKindOf: DCNamedElement)
				ifTrue: [ col add: 'name: ' , it name ].
			col ].
	aTree expandRoots.
	model when: DCModelEvent do: [ :event | aTree updateTree ]