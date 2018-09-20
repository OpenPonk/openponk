opening
openViews
	self ensureViewsLoaded.
	(project views sorted: #order ascending)
		select: #isOpen
		thenDo: [ :each | workbench openEditorOnView: each ].
	(project views select: #isOpen)
		detect: #isSelected
		ifFound: [ :view | workbench openEditorOnView: view ].
	(project views isNotEmpty and: [ project views noneSatisfy: #isOpen ])
		ifTrue: [ workbench openEditorOnView: project views first ]