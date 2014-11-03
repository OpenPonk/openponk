running
testDerivation
	| derivation |
	derivation := Derivation
				name: 'Derivation'
				start: (Relator name: 'Relator' metaModel: metaModel) 
				startMultiplicity: '1'
				end: (MaterialAssociation
						name: 'MaterialAssociation'
						start: (Role name: 'Role' metaModel: metaModel)
						end: (Role name: 'Role2' metaModel: metaModel))
				endMultiplicity: '1..*'.
	self assert: derivation isElementValid.
	
	derivation endMultiplicity: '0..n'.
	
	self deny: derivation isElementValid
	