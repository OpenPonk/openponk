userinterface
rebuild
	super rebuild.
	RTHorizontalTreeLayout on: self view elements.
	self view canvas camera focusOnCenter