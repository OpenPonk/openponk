initialization
initializePresenter
	newProjectButton
		action: [ 
			DCWorkbench openNewProject.
			self delete ].
	openFromFileButton action: [ self askForFileNameToOpen ].
	recentProjectsList whenSelectedItemChanged: [ :item | self openFile: item value ]