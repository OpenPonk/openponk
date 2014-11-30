initialization
initializeWidgets
	recentProjectsLabel := self newLabel.
	recentProjectsList := self newList.
	quickStartLabel := self newLabel.
	newProjectButton := self newButton.
	openFromFileButton := self newButton.
	recentProjectsLabel label: 'Recent Projects'.
	quickStartLabel label: 'Quick Start'.
	newProjectButton label: 'Create New Project'.
	openFromFileButton label: 'Open...'.
	recentProjectsList items: self class RecentProjects.
	self focusOrder
		add: recentProjectsList;
		add: newProjectButton;
		add: openFromFileButton