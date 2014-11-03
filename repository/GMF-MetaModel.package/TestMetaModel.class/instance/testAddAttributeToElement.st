running
testAddAttributeToElement
	| element |
	element := Kind name: 'ElementWithAttr' metaModel: metaModel.
	Attribute name: 'TestAttr' dataType: 'string'  multiplicity: '0'  element: element.
	
	self assert: ( element searchAttribute: 'TestAttr' ) notNil.
	