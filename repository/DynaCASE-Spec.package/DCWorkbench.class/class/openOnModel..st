project handling
openOnModel: aModel
	| project |
	project := DCProject named: 'New Project'.
	project addModel: aModel.
	self openProject: project