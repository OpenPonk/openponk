actions
chooseFolder
	| newFolder |
	newFolder := UIManager default chooseDirectory.
	newFolder ifNil: [ ^ self ].
	selectedFolder := newFolder fullName.
	self updateFolderInput