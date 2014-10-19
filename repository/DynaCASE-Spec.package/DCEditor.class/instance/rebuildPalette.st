as yet unclassified
rebuildPalette
	diagramController
		ifNotNil: [ 
			paletteModel removeAll.
			diagramController initializePalette: paletteModel editor: self ].
	paletteModel rebuildWidget