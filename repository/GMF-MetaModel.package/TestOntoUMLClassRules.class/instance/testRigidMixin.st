running
testRigidMixin
	| rigidMixin |
	rigidMixin := RigidMixinClass
				name: 'OnlyForTest' 
				abstract: true
				metaModel: metaModel.
				
	self assert: rigidMixin isElementValid.
	
	Generalization
		parent: (RoleMixin name: 'RoleMixin' metaModel: metaModel)
		child: rigidMixin
		generalizationSet: (GeneralizationSet new).
		
	self deny: rigidMixin isElementValid