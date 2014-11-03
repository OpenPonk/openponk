userinterface
rebuild
	super rebuild.
	RTHorizontalTreeLayout on: self view elements.
	self updateView.
	self view canvas camera focusOnCenter