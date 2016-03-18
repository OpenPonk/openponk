project handling
openOnDiagram: aDiagram
	| project |
	project := DCProject named: 'New Project'.
	project addModel: aDiagram.
	self openProject: project