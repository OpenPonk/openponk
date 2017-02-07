initialization
initializePresenter
	projectNameInput whenTextChanged: [ :newValue | self updateFolderInput ].
	projectFolderButton action: [ self chooseFolder ]