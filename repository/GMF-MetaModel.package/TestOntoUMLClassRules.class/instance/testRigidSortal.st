running
testRigidSortal
	| rigidSortal |
	rigidSortal := Kind name: 'RigidSortal' metaModel: metaModel.
	Generalization
		parent: (Mixin name: 'Mixin' metaModel: metaModel)
		child: rigidSortal
		generalizationSet: (GeneralizationSet new).
		
	self assert: rigidSortal isElementValid.
	
	Generalization
		parent: (Phase name: 'Phase' metaModel: metaModel)
		child: rigidSortal
		generalizationSet: (GeneralizationSet new).
		
	self deny: rigidSortal isElementValid