initialization
initializePalette: aPalette
	aPalette
		newCreationTool: 'Kind' factory: [ DCOmlKindController new ];
		newSeparator;
		newConnectionCreationTool: 'Basic Association' factory: [  ]