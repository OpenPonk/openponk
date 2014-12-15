initialization
initializeWidgets
	topMenuModel := self instantiate: MenuModel.
	navigatorModel := self instantiate: DCNavigator.
	tabManager := self newTabManager.
	formModel := self instantiate: DCDynamicForm.

	self focusOrder
		add: topMenuModel;
		add: navigatorModel;
		add: tabManager;
		add: formModel