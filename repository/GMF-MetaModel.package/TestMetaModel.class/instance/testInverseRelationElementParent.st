running
testInverseRelationElementParent
	| element |
	element := SubKind name: 'SubKindTestElement' metaModel: metaModel.
	
	ParentClass parentClass: (Kind name: 'TestChildKind' metaModel: metaModel) child: element.
	 
	self assert: (element searchParent: 'TestChildKind') parentClass name = 'TestChildKind'
	