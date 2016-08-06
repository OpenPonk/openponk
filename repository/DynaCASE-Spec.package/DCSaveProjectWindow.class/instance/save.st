actions
save
	projectController project storageFolder: self projectFolderInput text.
	projectController project name: self projectNameInput text.
	self basicSave