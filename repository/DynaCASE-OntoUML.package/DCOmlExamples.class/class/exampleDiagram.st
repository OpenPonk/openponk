examples
exampleDiagram
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

	^ diagram