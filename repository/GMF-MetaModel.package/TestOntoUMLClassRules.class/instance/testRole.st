running
testRole
	| role |
	role := Role name: 'Role' metaModel: metaModel.
	
	self deny: role isElementValid.
	
	Generalization
		parent: (Kind name: 'Person' metaModel: metaModel)
		child: role
		generalizationSet: (GeneralizationSet new).
		
	Mediation
		name: 'Mediation'
		start: role
		end: (Role name: 'AnotherRole' metaModel: metaModel).
		
	self assert: role isElementValid