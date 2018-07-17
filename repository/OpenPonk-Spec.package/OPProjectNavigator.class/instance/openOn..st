accessing
openOn: aProject
	project := aProject.
	tree roots: {project}.
	project whenChanged: [ tree updateTree ].
	self whenBuiltDo: [ tree expandRoots ]