initialization
initializePalette: aPalette
	(DCOmlElementClassController withAllSubclasses select: [ :class | class isAbstract not ])
		do: [ :class | aPalette newCreationTool: (self paletteNameFor: class) factory: [ class new ] icon: Smalltalk ui icons dcOmlBoxIcon ].
	aPalette newSeparator.
	(DCOmlRelationshipController withAllSubclasses select: [ :class | class isAbstract not ])
		do: [ :class | 
			aPalette
				newConnectionCreationTool: (self paletteNameFor: class)
				factory: [ class new ]
				icon: Smalltalk ui icons dcFsmTransitionIcon ]