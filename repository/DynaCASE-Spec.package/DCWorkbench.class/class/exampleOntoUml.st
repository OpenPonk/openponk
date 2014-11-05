examples
exampleOntoUml
	| diagram project firstKind secondKind basicAssociation subKind generalization |
	project := DCProject new projectName: 'Example OntoUML'.
	diagram := DCOmlDiagram new.
	project addDiagram: diagram.
	firstKind := Kind new name: 'Universe'.
	secondKind := Kind new name: 'Star'.
	subKind := SubKind new name: 'Dwarf star'.
	(basicAssociation := BasicAssociation new)
		name: 'stars>';
		start: firstKind;
		end: secondKind;
		startMultiplicity: 1;
		endMultiplicity: '*'.
	generalization := ParentClass parentClass: secondKind child: subKind.
	diagram
		add: firstKind;
		add: secondKind;
		add: basicAssociation;
		add: generalization.
	^ self openProject: project