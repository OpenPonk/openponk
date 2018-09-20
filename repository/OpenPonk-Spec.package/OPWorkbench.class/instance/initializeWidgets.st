initialization
initializeWidgets
	topToolbar := self instantiate: OPWorkbenchToolbar.
	diagramWidget := self instantiate: OPDiagramViewsWidget.
	modelTree := self newTabManager.
	self initializeModelTree.
	modelTreeWidget := self instantiate: OPModelNavigator.
	navigatorModel := self instantiate: OPProjectNavigator.
	tabManager := self newTabManager.
	formModel := self instantiate: OPScrollableForm.
	self focusOrder
		add: topToolbar;
		add: diagramWidget;
		add: navigatorModel;
		add: formModel;
		add: tabManager