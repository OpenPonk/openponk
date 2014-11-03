running
testInverseRelationMetaModelElement
	| element |
	element := Kind name: 'TestInverseKind' metaModel: metaModel.
	
	self assert: (metaModel modelElements at: element name) name = 'TestInverseKind'