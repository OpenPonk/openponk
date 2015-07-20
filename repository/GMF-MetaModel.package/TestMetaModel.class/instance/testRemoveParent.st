running
testRemoveParent
	| generalizationSet car skoda mercedes trabant |
	
	car := Kind name: 'Car' metaModel: metaModel.
	skoda := SubKind name: 'Skoda' metaModel: metaModel.
	mercedes := SubKind name: 'Mercedes' metaModel: metaModel.
	trabant := SubKind name: 'Trabant' metaModel: metaModel.
	
	generalizationSet := GeneralizationSet new.
	Generalization
		parent: car
		child: skoda
		generalizationSet: (generalizationSet).
	Generalization
		parent: car
		child: mercedes
		generalizationSet: (generalizationSet).
	Generalization
		parent: car
		child: trabant
		generalizationSet: (generalizationSet).
		
	trabant removeParent: 'Car'.
	
	self assert: trabant generalizations size = 0.
	self assert: mercedes generalizations size = 1.
	self assert: skoda generalizations size = 1.
	
	
	
	
	