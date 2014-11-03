running
testAddMethodToElement
	| element |
	element := Kind name: 'ElementWithMethod' metaModel: metaModel.
	Method name: 'TestMethod' element: element.

	self assert: ( element searchMethod: 'TestMethod' ) notNil
	