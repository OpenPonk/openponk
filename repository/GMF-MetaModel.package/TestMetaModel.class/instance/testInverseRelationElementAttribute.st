running
testInverseRelationElementAttribute
	| element |
	element := Kind name: 'TestElement' metaModel: metaModel. 
	Attribute
		name: 'Attribute'
		dataType: 'string'
		multiplicity: '1'
		element: element.
		
	self assert: (element searchAttribute: 'Attribute') name = 'Attribute'