project handling
openOnDiagram: aDiagram
	| project |
	project := DCProject named: 'New Project'.
	project addDiagram: aDiagram.
	self openProject: project