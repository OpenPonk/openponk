running
testAddNonUniqueElement

	Kind name: 'TestElement' metaModel: metaModel. 
	Phase name: 'TestElementPhase' metaModel: metaModel.
	Role name: 'TestElement' metaModel: metaModel.
	
	self assert: (metaModel modelElements
			detect: [:each | each isMemberOf: Kind]) notNil & metaModel modelElements size = 2