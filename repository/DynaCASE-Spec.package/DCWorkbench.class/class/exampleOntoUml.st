examples
exampleOntoUml
	| diagram project firstKind secondKind basicAssociation |
	project := DCProject new projectName: 'Example OntoUML'.
	diagram := DCOmlDiagram new.
	project addDiagram: diagram.
	firstKind := Kind new name: 'Universe'.
	secondKind := Kind new name: 'Star'.
	(basicAssociation := BasicAssociation new)
		name: 'stars>';
		start: firstKind;
		end: secondKind;
		startMultiplicity: 1;
		endMultiplicity: '*'.
	diagram
		add: firstKind;
		add: secondKind;
		add: basicAssociation.
	^ self openProject: project