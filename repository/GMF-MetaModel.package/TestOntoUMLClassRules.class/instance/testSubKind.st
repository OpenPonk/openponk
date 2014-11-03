running
testSubKind
	| subKind |
	subKind := SubKind name: 'TestsubKind' metaModel: metaModel.
	ParentClass parentClass: ( Kind name: 'Parent' metaModel: metaModel ) child: subKind.
	
	self assert: subKind isElementValid.
	
	subKind removeParent: 'Parent'.
	
	self deny: subKind isElementValid.
	