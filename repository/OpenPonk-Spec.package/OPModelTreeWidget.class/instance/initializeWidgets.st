initialization
initializeWidgets
	tree := self newTree.
	self initializeTree.
	self focusOrder add: tree.
	self newWidgetHeading