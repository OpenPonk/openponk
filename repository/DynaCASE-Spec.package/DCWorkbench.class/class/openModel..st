project handling
openModel: aModel
	| project |
	project := DCProject named: 'Project'.
	project addModel: aModel.
	self openProject: project