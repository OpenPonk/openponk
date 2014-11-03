running
testInverseRelationElementAssociation
	| start end |
	FormalAssociation 
		name: 'containment'
		start: (start := Kind name: 'Bottle' metaModel: metaModel) 
		startMultiplicity: '1'
		end: (end := Quantity name: 'MineralWater' metaModel: metaModel)
		endMultiplicity: '1'.
	
	self assert: (( start searchAssociation: 'containment' ) name = 'containment').
	self assert: (( end searchAssociation: 'containment' ) name = 'containment')
	