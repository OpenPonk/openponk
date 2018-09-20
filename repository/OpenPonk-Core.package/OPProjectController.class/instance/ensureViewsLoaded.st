opening
ensureViewsLoaded
	(project models isNotEmpty and: [ project views isEmpty ])
		ifTrue: [ | views |
			views := project models collect: [ :each | OPDiagramView defaultViewFor: each ].
			project views: views ]