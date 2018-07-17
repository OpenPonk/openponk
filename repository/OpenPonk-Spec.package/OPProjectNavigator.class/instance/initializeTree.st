initialization
initializeTree
	tree
		doubleClick: [ self doubleClick ];
		menu: [ :menu | 
			tree hasSelectedItem
				ifTrue: [ adapters contextMenuFor: self selectedItem in: menu ] ];
		displayBlock: [ :anObject | adapters displayFor: anObject ];
		childrenBlock: [ :anObject | adapters childrenFor: anObject ];
		iconBlock: [ :anObject | adapters iconFor: anObject ].
	tree
		expandRoots;
		autoDeselection: false