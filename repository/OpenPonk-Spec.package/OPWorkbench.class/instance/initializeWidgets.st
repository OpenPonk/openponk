initialization
initializeWidgets
	topToolbar := self instantiate: OPWorkbenchToolbar.
	navigatorModel := self instantiate: OPModelNavigator.
	tabManager := self newTabManager.
	formModel := self instantiate: OPScrollableForm.
	self focusOrder
		add: topToolbar;
		add: navigatorModel;
		add: formModel;
		add: tabManager