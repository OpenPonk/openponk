initialization
initializePalette: aPalette
	aPalette
		newCreationTool: 'Initial state'
			factory: [ DCFsmInitialStateController new ]
			icon: Smalltalk ui icons dcFsmInitialStateIcon;
		newSeparator;
		newCreationTool: 'State' factory: [ DCFsmStateController new ] icon: Smalltalk ui icons dcFsmRegularStateIcon;
		newCreationTool: 'Final state'
			factory: [ DCFsmFinalStateController new ]
			icon: Smalltalk ui icons dcFsmFinalStateIcon;
		newSeparator;
		newConnectionCreationTool: 'Transition'
			factory: [ DCFsmTransitionController new ]
			icon: Smalltalk ui icons dcFsmTransitionIcon