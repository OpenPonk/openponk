running
testRole
	| role |
	role := Role name: 'Role' metaModel: metaModel.
	
	self deny: role isElementValid.
	
	ParentClass
		parentClass: (Kind name: 'Person' metaModel: metaModel)
		child: role.
	Mediation
		name: 'Mediation'
		start: role
		end: (Role name: 'AnotherRole' metaModel: metaModel).
		
	self assert: role isElementValid