instance creation
openNewProject
	| project diagram |
	project := DCProject new projectName: 'New Project'.
	diagram := DCOmlDiagram new.
	project addDiagram: diagram.
	^ self openProject: project