initialization
initializePresenter
	nameField whenTextChanged: [ :newValue | self element ifNotNil: [ self element name: newValue ] ]