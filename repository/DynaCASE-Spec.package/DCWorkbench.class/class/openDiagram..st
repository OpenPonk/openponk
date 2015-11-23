project handling
openDiagram: aDiagram
	| project |
	project := DCProject named: 'Project'.
	project addDiagram: aDiagram.
	self openProject: project