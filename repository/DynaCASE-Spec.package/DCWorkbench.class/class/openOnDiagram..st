project handling
openOnDiagram: aDiagram
	| project |
	project := DCProject named: 'New Project'.
	project add: aDiagram.
	self openProject: project