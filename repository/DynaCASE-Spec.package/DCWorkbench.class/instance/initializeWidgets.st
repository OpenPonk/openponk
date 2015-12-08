initialization
initializeWidgets
	topToolbar := self instantiate: DCWorkbenchToolbar.
	navigatorModel := self instantiate: DCNavigator.
	tabManager := self newTabManager.
	formModel := self instantiate: DCDynamicForm.

	self focusOrder
		add: navigatorModel;
		add: tabManager;
		add: formModel