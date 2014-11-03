running
testSubsranceSortal
	| element |
	element := Kind name: 'TestElement' metaModel: metaModel.
	
	self assert: element isElementValid.
	
	ParentClass parentClass: ( Kind name: 'RigidSortal' metaModel: metaModel ) child: element.
	
	self deny: element isElementValid
	