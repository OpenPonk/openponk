running
testQuantity
	| quantity kind |
	quantity := Quantity name: 'TestQuantity' metaModel: metaModel.
	kind := Kind name: 'TestKind' metaModel: metaModel.
	FormalAssociation 
		name: 'containment'
		start: quantity
		startMultiplicity: '1'
		end: kind
		endMultiplicity: '1'.
		
	self assert: quantity isElementValid.
	
	MaterialAssociation
		name: 'Test'
		start: quantity
		end: kind.
		
	self deny: quantity isElementValid