running
testNonSortal
	| nonSortal |
	nonSortal := MixinClass
				name: 'OnlyForTesting'
				abstract: true
				metaModel: metaModel.
				
	self assert: nonSortal isElementValid.
	
	Generalization
		parent: (Kind name: 'Parent' metaModel: metaModel)
		child: nonSortal
		generalizationSet: (GeneralizationSet new).
		
	self deny: nonSortal isElementValid