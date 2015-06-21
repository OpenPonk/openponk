*DynaCASE-OntoUML
exampleOntoUml
	<example:'DynaCASE example OntoUML'>
	| diagram project firstKind secondKind basicAssociation subKind generalization |
	project := DCProject new projectName: 'Example OntoUML'.
	diagram := DCOmlDiagram new name: 'OntoUML diagram'.
	project addDiagram: diagram.
	firstKind := Kind new name: 'Universe'.
	secondKind := Kind new name: 'Star'.
	secondKind attributes: { 'size: Integer[1]'. 'color: Color[1]' } asOrderedCollection.
	secondKind methods: { '/expand(newSize: Integer[1])/' } asOrderedCollection.
	subKind := SubKind new name: 'Dwarf star'.
	(basicAssociation := BasicAssociation new)
		name: 'stars>';
		start: firstKind;
		end: secondKind;
		startMultiplicity: 1;
		endMultiplicity: '*'.
	generalization := Generalization new parent: secondKind; child: subKind; yourself.
	diagram
		add: firstKind;
		add: secondKind;
		add: basicAssociation;
		add: generalization.
	^ self openProject: project