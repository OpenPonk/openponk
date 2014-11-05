initialization
initializePalette: aPalette
	| matcher name |
	matcher := 'DCOml(.*)Controller' asRegex.

	(DCOmlElementClassController withAllSubclasses select: [ :class | class isAbstract not ])
		do: [ :class | 
			matcher matches: class asString.
			name := matcher subexpression: 2.
			aPalette newCreationTool: name factory: [ class new ] ].
	aPalette newSeparator.

	(DCOmlRelationshipController withAllSubclasses select: [ :class | class isAbstract not ])
		do: [ :class | 
			matcher matches: class asString.
			name := matcher subexpression: 2.
			aPalette newConnectionCreationTool: name factory: [ class new ] ]