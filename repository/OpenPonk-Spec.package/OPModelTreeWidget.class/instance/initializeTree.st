initialization
initializeTree
	tree
		roots: {};
		doubleClick: [ self doubleClick ];
		menu: [ :menu | 
			tree hasSelectedItem
				ifTrue: [ adapters contextMenuFor: self selectedItem in: menu ] ];
		displayBlock: [ :anObject | adapters displayFor: anObject ];
		childrenBlock: [ :anObject | 
			(adapters childrenFor: anObject)
				sorted: [ :a :b | (tree displayBlock value: a) < (tree displayBlock value: b) ] ];
		iconBlock: [ :anObject | adapters iconFor: anObject ].
	tree
		expandRoots;
		autoDeselection: false