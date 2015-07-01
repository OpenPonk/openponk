examples
exampleEmpty
"	| project diagram |
	project := DCProject named: 'UML Class Diagram'.
	diagram := DUmlClassDiagram named: 'UML Class Diagram'.
	project addDiagram: diagram.

	DCWorkbench openProject: project"