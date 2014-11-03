running
testRoleMixin
	| roleMixin |
	roleMixin := RoleMixin
				name: 'RoleMixin'
				abstract: true
				metaModel: metaModel.
				
	self deny: roleMixin isElementValid.
	
	Mediation
		name: 'Mediation'
		start: roleMixin
		end: (Relator name: 'Relator' metaModel: metaModel).
		
	self deny: roleMixin isElementValid.
	
	roleMixin
		addRole: (Role name: 'MixedRole' metaModel: metaModel).
		
	self assert: roleMixin isElementValid