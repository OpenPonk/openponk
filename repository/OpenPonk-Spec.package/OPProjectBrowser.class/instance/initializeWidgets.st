initialization
initializeWidgets
	recentLabel := self newLabel label: 'Recent Projects'.
	recentList := self instantiate: FastTableModel.
	quickStartLabel := self newLabel label: 'Quick Start'.
	projectNameInput := self newTextInput text: 'New Project'.
	createProjectButton := self newButton label: 'Create Project'.
	openProjectButton := self newButton label: 'Open Project...'.
	pluginRegistry
		pluginsDo: [ :each | 
			(diagramOptions
				at: (each modelClass asString uncapitalized , 'Radio') asSymbol
				put: (Array with: each with: (self newRadioButton label: each name))) second
				whenBuiltDo: [ :event | event model widget hSpaceFill ] ].
	self setGroup