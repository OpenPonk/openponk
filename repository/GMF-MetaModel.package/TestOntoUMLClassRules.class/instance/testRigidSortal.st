running
testRigidSortal
	| rigidSortal |
	rigidSortal := Kind name: 'RigidSortal' metaModel: metaModel.
	ParentClass
		parentClass: (Mixin name: 'Mixin' metaModel: metaModel)
		child: rigidSortal.
		
	self assert: rigidSortal isElementValid.
	
	ParentClass
		parentClass: (Phase name: 'Phase' metaModel: metaModel)
		child: rigidSortal.
		
	self deny: rigidSortal isElementValid