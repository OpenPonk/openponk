examples
exampleDiagram
	| diagram project |
	project := DCProject new projectName: 'Example OntoUML Diagram'.
	diagram := self createExampleDiagram.
	project addDiagram: diagram.
	^ DCWorkbench openProject: project