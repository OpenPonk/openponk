running
testNonSortal
	| nonSortal |
	nonSortal := MixinClass
				name: 'OnlyForTesting'
				abstract: true
				metaModel: metaModel.
				
	self assert: nonSortal isElementValid.
	
	ParentClass
		parentClass: (Kind name: 'Parent' metaModel: metaModel)
		child: nonSortal.
		
	self deny: nonSortal isElementValid