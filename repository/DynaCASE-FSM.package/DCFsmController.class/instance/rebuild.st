userinterface
rebuild
	super rebuild.
	RTHorizontalTreeLayout new
		horizontalGap: 50;
		on: self view elements.
	self view canvas camera focusOnCenter