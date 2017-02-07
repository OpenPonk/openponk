initialization
initializeWidgets
	(projectNameLabel := self newLabel) label: 'Project name'.
	(projectNameInput := self newTextInput) autoAccept: true.
	(projectFolderLabel := self newLabel) label: 'Project folder'.
	(projectFolderInput := self newTextInput) autoAccept: true.
	(projectFolderButton := self newButton) label: '...'