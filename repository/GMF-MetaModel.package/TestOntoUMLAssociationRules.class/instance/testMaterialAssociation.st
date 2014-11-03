running
testMaterialAssociation
	| materialAssociation |
	materialAssociation := MaterialAssociation
				name: 'Material'
				start: (Role name: 'Student' metaModel: metaModel)
				startMultiplicity: '0..*'
				end: (Role name: 'School' metaModel: metaModel)
				endMultiplicity: '1..n'.
				
	self deny: materialAssociation isElementValid.
	
	materialAssociation startMultiplicity: '1..*'.
	Derivation
		name: 'Derivation'
		start: (Relator name: 'Relator' metaModel: metaModel)
		startMultiplicity: '1'
		end: materialAssociation
		endMultiplicity: '1..*'.
	
	self assert: materialAssociation isElementValid