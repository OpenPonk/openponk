running
testSubsranceSortal
	| element |
	element := Kind name: 'TestElement' metaModel: metaModel.
	
	self assert: element isElementValid.
	
	Generalization 
		parent: ( Kind name: 'RigidSortal' metaModel: metaModel ) 
		child: element
		generalizationSet: (GeneralizationSet new).
	
	self deny: element isElementValid
	