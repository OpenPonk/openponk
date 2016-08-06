accessing
projectController: aProjectController
	projectController := aProjectController.
	projectNameInput
		text: (projectController project name asLowercase copyReplaceAll: ' ' with: '-')