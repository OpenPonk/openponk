initialization
initializePalette: aPalette
	(DCOmlElementClassController withAllSubclasses reject: [ :class | class isAbstract ])
		do: [ :class | aPalette newCreationTool: (self paletteNameFor: class) factory: [ class new ] icon: Smalltalk ui icons dcOmlBoxIcon ].
	aPalette newSeparator.
	(DCOmlRelationshipController withAllSubclasses reject: [ :class | class isAbstract ])
		do: [ :class | 
			aPalette
				newConnectionCreationTool: (self paletteNameFor: class)
				factory: [ class new ]
				icon: Smalltalk ui icons dcFsmTransitionIcon ]