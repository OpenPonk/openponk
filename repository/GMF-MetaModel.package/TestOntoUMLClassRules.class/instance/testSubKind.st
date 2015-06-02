running
testSubKind
	| subKind |
	subKind := SubKind name: 'TestsubKind' metaModel: metaModel.
	Generalization
		parent: ( Kind name: 'Parent' metaModel: metaModel ) 
		child: subKind
		generalizationSet: (GeneralizationSet new).
	
	self assert: subKind isElementValid.
	
	subKind removeParent: 'Parent'.
	
	self deny: subKind isElementValid.
	