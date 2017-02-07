project handling
openOnModel: aModel
	| project |
	project := OPProject named: 'New Project'.
	project addModel: aModel.
	self openProject: project