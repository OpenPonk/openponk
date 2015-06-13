userinterface
rebuild
	super rebuild.
	RTHorizontalTreeLayout new
		horizontalGap: 50;
		on: (self controllers select: [ :each | each isKindOf: DCFsmVertexController ] thenCollect: #figure).
	self view canvas camera focusOnCenter