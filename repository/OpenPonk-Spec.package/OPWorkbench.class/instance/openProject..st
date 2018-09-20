project handling
openProject: aProject
	project := aProject.
	(projectController := aProject controllerClass new)
		project: project;
		workbench: self.
	self updateTitle.
	topToolbar updateProjectMenu.
	project whenChanged: [ self updateTitle ].
	diagramWidget project: project.
	navigatorModel openOn: project.
	modelTreeWidget openOn: project.
	projectController openViews