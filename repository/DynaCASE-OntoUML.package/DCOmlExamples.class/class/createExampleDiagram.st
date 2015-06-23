as yet unclassified
createExampleDiagram
	| diagram modelK elementK diagramK projectK attributeBuilder methodBuilder |
	diagram := DCOmlDiagram named: 'OntoUML diagram'.
	modelK := Kind named: 'DCModelObject'.
	elementK := SubKind named: 'DCNamedElement'.
	diagramK := SubKind named: 'DCDiagram'.
	projectK := Kind named: 'DCProject'.

	attributeBuilder := DCOmlAttributeBuilder new.
	#('-dcID: UUID' '-dcName: String') do: [ :line | (attributeBuilder parse: line) element: modelK ].

	methodBuilder := DCOmlMethodBuilder new.
	#('+name(): String[1]' '+name(aName: String)') do: [ :line | (methodBuilder parse: line) element: modelK ].

	diagram
		add: modelK;
		add: elementK;
		add: diagramK;
		add: projectK.

	diagram
		add: (Generalization parent: modelK child: elementK generalizationSet: GeneralizationSet new);
		add: (Generalization parent: modelK child: diagramK generalizationSet: GeneralizationSet new).

	diagram
		add:
			(BasicAssociation
				name: 'elements'
				start: diagramK
				startMultiplicity: '0..1'
				end: elementK
				endMultiplicity: '*').

	diagram
		add:
			(BasicAssociation
				name: 'owner'
				start: modelK
				startMultiplicity: '*'
				end: modelK
				endMultiplicity: '0..1').

	diagram
		add:
			(BasicAssociation
				name: 'diagrams'
				start: projectK
				startMultiplicity: '0..1'
				end: diagramK
				endMultiplicity: '*').


	^ diagram