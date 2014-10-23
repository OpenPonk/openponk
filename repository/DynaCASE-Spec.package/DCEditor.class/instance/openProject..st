project handling
openProject: aProject
	self assert: aProject class = DCProject.
	project ifNotNil: [ self closeProject ].
	project := aProject.
	self updateTitle.
	project whenDirtyChanged: [ self updateTitle ].
	project openedIn: self.
	aProject initializeTree: treeModel.