running
testAddAssociationToElement
	| start end |
	start := Quantity name: 'Minerals' metaModel: metaModel.
	end := Quantity name: 'MineralWater' metaModel: metaModel.
				
	SubQuantityOf
		name: 'quantity'
		start: start
		startMultiplicity: '1'
		end: end
		endMultiplicity: '1'.
		
	self assert: (start searchAssociation: 'quantity') notNil & (end searchAssociation: 'quantity') notNil 