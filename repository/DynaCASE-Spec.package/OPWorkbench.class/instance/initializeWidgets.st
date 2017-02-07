initialization
initializeWidgets
	topToolbar := self instantiate: OPWorkbenchToolbar.
	navigatorModel := self instantiate: OPNavigator.
	tabManager := self newTabManager.
	formModel := self instantiate: OPDynamicForm.

	self focusOrder
		add: navigatorModel;
		add: tabManager;
		add: formModel