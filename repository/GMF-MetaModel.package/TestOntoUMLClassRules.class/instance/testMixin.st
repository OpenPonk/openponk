running
testMixin
	| mixin |
	mixin := Mixin
				name: 'Mixin'
				abstract: true
				metaModel: metaModel.
				
	self deny: mixin isElementValid.
	
	mixin
		addObject: (Kind name: 'MixedObject' metaModel: metaModel).
	mixin
		addObject: (Phase name: 'MixedPhase' metaModel: metaModel).
		
	self assert: mixin isElementValid