actions
chooseFolder
	FDOpenDirectoryDialog new
		whenSelected: [ :folder | 
			selectedFolder := folder fullName.
			self updateFolderInput ];
		open