as yet unclassified
rebuildPalette
	diagramController
		ifNotNil: [ 
			paletteModel removeAll.
			diagramController initializePalette: paletteModel editor: self ].
	paletteModel
		addGroup: [ :group | 
					group
						name: 'Actions';
						addItem: [ :item | 
									item
										name: 'Cancel selection';
										action: [ 
													self canvasModel cancelFocus.
													self canvasModel cancelSelection ] ] ];
		rebuildWidget