as yet unclassified
exampleEmpty
	| diagram project |
	project := DCProject new projectName: 'Example OntoUML Diagram'.
	diagram := DCOmlDiagram named: 'OntoUML Diagram'.
	project addDiagram: diagram.
	^ DCWorkbench openProject: project