project handling
openDiagram: aDiagram
	| project |
	project := DCProject named: 'Project'.
	project addModel: aDiagram.
	self openProject: project