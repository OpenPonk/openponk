initialization
initializePresenter
	newProjectButton
		action: [ 
			DCWorkbench openNewProject.
			self delete ].
	openFromFileButton action: [ self askForFileNameToOpen ].
	recentProjectsList
		handlesDoubleClick: true;
		doubleClick: [ :event | event inspect	"self openFile: item value" ];
		menu: [ :menu | self rightClickMenu: menu ]