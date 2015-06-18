running
testInverseRelationElementParent
	| element |
	element := SubKind name: 'SubKindTestElement' metaModel: metaModel.
	
	Generalization 
		parent: (Kind name: 'TestChildKind' metaModel: metaModel) 
		child: element
		generalizationSet: (GeneralizationSet new).
	 
	self assert: (element searchParent: 'TestChildKind') parent name = 'TestChildKind'
	