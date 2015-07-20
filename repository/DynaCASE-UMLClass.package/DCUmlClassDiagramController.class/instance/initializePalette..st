initialization
initializePalette: aPalette
	aPalette
		newCreationTool: 'Class' factory: [ DCUmlClassController new ] icon: DCIcons current dcOmlBoxIcon;
		newSeparator;
		newConnectionCreationTool: 'Association'
			factory: [ DCUmlAssociationController new ]
			icon: DCIcons current dcFsmTransitionIcon.
		