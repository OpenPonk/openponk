initialization
initialize
	selectedFolder := Smalltalk imageDirectory fullName.
	super initialize.
	projectNameInput text: 'New Project'