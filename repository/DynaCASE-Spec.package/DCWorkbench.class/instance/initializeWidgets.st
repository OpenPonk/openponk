initialization
initializeWidgets
	topMenuModel := self instantiate: MenuModel.
	navigatorModel := self instantiate: DCNavigator.
	editorModel := self instantiate: DCEditor.
	formModel := self instantiate: DCDynamicForm.
	self focusOrder
		add: topMenuModel;
		add: navigatorModel;
		add: editorModel;
		add: formModel