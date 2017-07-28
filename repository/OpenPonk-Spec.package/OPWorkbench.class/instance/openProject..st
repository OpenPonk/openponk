project handling
openProject: aProject
	project := aProject.
	(projectController := aProject controllerClass new)
		project: project;
		workbench: self.
	self updateTitle.
	topToolbar updateProjectMenu.
	project whenChanged: [ self updateTitle ].
	navigatorModel openOn: project.
	projectController openFirstDiagram