project handling
openModel: aModel
	| project |
	project := OPProject named: 'Project'.
	project addModel: aModel.
	self openProject: project