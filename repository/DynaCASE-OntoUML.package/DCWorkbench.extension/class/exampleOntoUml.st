*DynaCASE-OntoUML
exampleOntoUml
	<example: 'DynaCASE example OntoUML'>
	| diagram project |
	project := DCProject new projectName: 'Example OntoUML'.
	diagram := DCOmlExamples exampleDiagram.
	project addDiagram: diagram.
	^ self openProject: project