initialization
initializePalette: aPalette
	| matcher name |
	matcher := 'DCOml(.*)Controller' asRegex.

	DCOmlElementClassController
		withAllSubclassesDo: [ :class | 
			matcher matches: class asString.
			name := matcher subexpression: 2.
			aPalette newCreationTool: name factory: [ class new ] ].
	aPalette newSeparator.

	DCOmlElementAssociationController
		withAllSubclassesDo: [ :class | 
			matcher matches: class asString.
			name := matcher subexpression: 2.
			aPalette newConnectionCreationTool: name factory: [ class new ] ]