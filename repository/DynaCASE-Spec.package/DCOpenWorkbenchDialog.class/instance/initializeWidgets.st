initialization
initializeWidgets
	recentProjectsLabel := self newLabel.
	recentProjectsList := self instantiate: NewListModel.
	quickStartLabel := self newLabel.
	newProjectButton := self newButton.
	openFromFileButton := self newButton.
	recentProjectsLabel label: 'Recent Projects'.
	quickStartLabel label: 'Quick Start'.
	newProjectButton label: 'Create New Project'.
	openFromFileButton label: 'Open...'.
	self updateRecentProjects.
	self focusOrder
		add: recentProjectsList;
		add: newProjectButton;
		add: openFromFileButton