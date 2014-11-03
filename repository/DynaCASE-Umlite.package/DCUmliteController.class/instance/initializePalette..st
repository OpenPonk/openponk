initialization
initializePalette: aPalette
	aPalette
		newCreationTool: 'Class' factory: [ DCUmliteClassController new ];
		newSeparator;
		newConnectionCreationTool: 'Association' factory: [ DCUmliteAssociationController new ]