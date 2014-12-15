project handling
openProject: aProject
	self assert: aProject class = DCProject.
	project := aProject.
	(projectController := DCProjectController new)
		project: project;
		editor: self editorModel;
		workbench: self.
	self updateTitle.
	project whenChanged: [ self updateTitle ].
	navigatorModel openOn: project.
	project beClean.
	projectController openFirstDiagram