initialization
initializeWidgets
	topToolbar := self instantiate: OPWorkbenchToolbar.
	diagramWidget := self instantiate: OPDiagramWidget.
	navigatorModel := self instantiate: OPModelNavigator.
	tabManager := self newTabManager.
	formModel := self instantiate: OPScrollableForm.
	self focusOrder
		add: topToolbar;
		add: diagramWidget;
		add: navigatorModel;
		add: formModel;
		add: tabManager