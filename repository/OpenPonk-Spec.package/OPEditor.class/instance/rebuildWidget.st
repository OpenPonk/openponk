updating
rebuildWidget
	diagramController ifNotNil: [ paletteModel createPaletteFor: diagramController ].
	canvasModel needRebuild: false.
	self needRebuild: false.
	self buildWithSpec