examples
exampleOntoUml
	| diagram project firstKind secondKind |
	project := DCProject new projectName: 'Example OntoUML'.
	diagram := DCOmlDiagram new.
	project addDiagram: diagram.
	firstKind := Kind new name: 'Universe'.
	secondKind := Kind new name: 'Star'.
	diagram
		add: firstKind;
		add: secondKind.
	^ self openProject: project