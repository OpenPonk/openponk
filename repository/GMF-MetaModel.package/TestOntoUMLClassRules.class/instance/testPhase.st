running
testPhase
	| phase |
	phase := Phase name: 'NewPhase' metaModel: metaModel.
	ParentClass
		parentClass: (Kind name: 'PhaseParent' metaModel: metaModel)
		child: phase.
	self assert: phase isElementValid.
	
	(phase searchParent: 'PhaseParent')
		disjoint: false.
		
	self deny: phase isElementValid