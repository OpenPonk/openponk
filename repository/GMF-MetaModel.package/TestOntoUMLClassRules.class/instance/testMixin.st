running
testMixin
	| mixin generalizationSet |
	mixin := Mixin
				name: 'Mixin'
				abstract: true
				metaModel: metaModel.
				
	self deny: mixin isElementValid.
	
	generalizationSet := GeneralizationSet new.
	
	mixin
		addObject: (Kind name: 'MixedObject' metaModel: metaModel)
		generalizationSet: generalizationSet.
	mixin
		addObject: (Phase name: 'MixedPhase' metaModel: metaModel)
		generalizationSet: generalizationSet.
		
	self assert: mixin isElementValid