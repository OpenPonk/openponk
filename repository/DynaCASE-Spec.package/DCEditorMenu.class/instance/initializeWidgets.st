initialization
initializeWidgets
	menuModel := self instantiate: MenuModel.
	self focusOrder
		add: menuModel