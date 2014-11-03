as yet unclassified
rebuildPalette
	diagramController ifNotNil: [ paletteModel createPaletteFor: diagramController ].
	paletteModel rebuildWidget