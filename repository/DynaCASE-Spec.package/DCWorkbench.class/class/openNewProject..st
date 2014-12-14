as yet unclassified
openNewProject: aName
	| project diagram |
	project := DCProject new projectName: aName.
	diagram := DCOmlDiagram new.
	project addDiagram: diagram.
	^ self openProject: project