initialization
initializePresenter
	newProjectButton action: [ self createNewProject ].
	openFromFileButton action: [ self askForFileNameToOpen ].
	recentProjectsList
		handlesDoubleClick: true;
		doubleClickAction: [ :event | self openFromList ];
		menu: [ :menu | self rightClickMenu: menu ]