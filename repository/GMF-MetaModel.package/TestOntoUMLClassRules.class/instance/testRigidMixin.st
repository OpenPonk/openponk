running
testRigidMixin
	| rigidMixin |
	rigidMixin := RigidMixinClass
				name: 'OnlyForTest' 
				abstract: true
				metaModel: metaModel.
				
	self assert: rigidMixin isElementValid.
	
	ParentClass
		parentClass: (RoleMixin name: 'RoleMixin' metaModel: metaModel)
		child: rigidMixin.
		
	self deny: rigidMixin isElementValid