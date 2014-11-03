running
testInverseRelationElementMethod
	| element |
	element := Kind name: 'TestElement' metaModel: metaModel. 
	Method name: 'Method' element: element. 
		
	self assert: (element searchMethod: 'Method') name = 'Method'
	
	
	