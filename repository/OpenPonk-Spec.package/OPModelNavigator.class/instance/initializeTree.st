initialization
initializeTree
	tree
		roots: project models;
		doubleClick: [ self doubleClick ];
		menu: [ :menu | self contextMenu: menu ];
		displayBlock: [ :anObject | self displayFor: anObject ];
		childrenBlock: [ :anObject | self childrenFor: anObject ];
		iconBlock: [ :anObject | self iconFor: anObject ].
	tree
		expandRoots;
		autoDeselection: false.
	project whenChanged: [ tree updateTree ]