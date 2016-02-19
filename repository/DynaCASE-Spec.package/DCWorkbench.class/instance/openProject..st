project handling
openProject: aProject
	self assert: [ aProject isKindOf: DCProject ].
	project := aProject.
	(projectController := DCProjectController new)
		project: project;
		workbench: self.
	self updateTitle.
	project whenChanged: [ self updateTitle ].
	navigatorModel openOn: project.
	project beClean.
	projectController openFirstDiagram