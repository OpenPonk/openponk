running
testPhase
	| phase generalizationSet |
	
	generalizationSet := GeneralizationSet new.
	phase := Phase name: 'NewPhase' metaModel: metaModel.
	Generalization
		parent: (Kind name: 'PhaseParent' metaModel: metaModel)
		child: phase
		generalizationSet: generalizationSet.
	self assert: phase isElementValid.
	
	generalizationSet
		disjoint: false.
		
	self deny: phase isElementValid