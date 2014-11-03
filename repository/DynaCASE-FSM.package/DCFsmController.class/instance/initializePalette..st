initialization
initializePalette: aPalette
	aPalette
		newCreationTool: 'Initial' factory: [ DCFsmInitialStateController new ];
		newSeparator;
		newCreationTool: 'State' factory: [ DCFsmStateController new ];
		newCreationTool: 'Final state' factory: [ DCFsmFinalStateController new ];
		newSeparator;
		newConnectionCreationTool: 'Transition' factory: [ DCFsmTransitionController new ]